#!/usr/bin/ruby -Ku
#
# This is pure Ruby implementing Punycode (RFC 3492).
# (original ANSI C code (C89) implementing Punycode is in RFC 3492)
#
# copyright (c) 2005 Kazuhiro NISHIYAMA
# You can redistribute it and/or modify it under the same terms as Ruby.
#

module Punycode
  module Status
    class Error < StandardError; end
    class PunycodeSuccess; end
    # Input is invalid.
    class PunycodeBadInput < Error; end
    # Output would exceed the space provided.
    class PunycodeBigOutput< Error; end
    # Input needs wider integers to process.
    class PunycodeOverflow < Error; end
  end
  include Status

  # *** Bootstring parameters for Punycode ***

  BASE = 36; TMIN = 1; TMAX = 26; SKEW = 38; DAMP = 700
  INITIAL_BIAS = 72; INITIAL_N = 0x80; DELIMITER = 0x2D

  module_function

  # basic(cp) tests whether cp is a basic code point:
  def basic(cp)
    cp < 0x80
  end

  # delim(cp) tests whether cp is a delimiter:
  def delim(cp)
    cp == DELIMITER
  end

  # decode_digit(cp) returns the numeric value of a basic code
  # point (for use in representing integers) in the range 0 to
  # base-1, or base if cp is does not represent a value.
  def decode_digit(cp)
    cp - 48 < 10 ? cp - 22 :  cp - 65 < 26 ? cp - 65 :
      cp - 97 < 26 ? cp - 97 : BASE
  end

  # encode_digit(d,flag) returns the basic code point whose value
  # (when used for representing integers) is d, which needs to be in
  # the range 0 to base-1.  The lowercase form is used unless flag is
  # nonzero, in which case the uppercase form is used.  The behavior
  # is undefined if flag is nonzero and digit d has no uppercase form.
  def encode_digit(d, flag)
    return d + 22 + 75 * ((d < 26) ? 1 : 0) - ((flag ? 1 : 0) << 5)
    #  0..25 map to ASCII a..z or A..Z
    # 26..35 map to ASCII 0..9
  end

  # flagged(bcp) tests whether a basic code point is flagged
  # (uppercase).  The behavior is undefined if bcp is not a
  # basic code point.
  def flagged(bcp)
    (0...26) === (bcp - 65)
  end

  # encode_basic(bcp,flag) forces a basic code point to lowercase
  # if flag is zero, uppercase if flag is nonzero, and returns
  # the resulting code point.  The code point is unchanged if it
  # is caseless.  The behavior is undefined if bcp is not a basic
  # code point.
  def encode_basic(bcp, flag)
    # bcp -= (bcp - 97 < 26) << 5;
    if (0...26) === (bcp - 97)
      bcp -= 1 << 5
    end
    # return bcp + ((!flag && (bcp - 65 < 26)) << 5);
    if !flag and (0...26) === (bcp - 65)
      bcp += 1 << 5
    end
    bcp
  end

  # *** Platform-specific constants ***

  # maxint is the maximum value of a punycode_uint variable:
  MAXINT = 1 << 64

  # *** Bias adaptation function ***

  def adapt(delta, numpoints, firsttime)
    delta = firsttime ? delta / DAMP : delta >> 1
    # delta >> 1 is a faster way of doing delta / 2
    delta += delta / numpoints

    k = 0
    while delta > ((BASE - TMIN) * TMAX) / 2
      delta /= BASE - TMIN
      k += BASE
    end

    k + (BASE - TMIN + 1) * delta / (delta + SKEW)
  end

  # *** Main encode function ***

  # punycode_encode() converts Unicode to Punycode.  The input
  # is represented as an array of Unicode code points (not code
  # units; surrogate pairs are not allowed), and the output
  # will be represented as an array of ASCII code points.  The
  # output string is *not* null-terminated; it will contain
  # zeros if and only if the input contains zeros.  (Of course
  # the caller can leave room for a terminator and add one if
  # needed.)  The input_length is the number of code points in
  # the input.  The output_length is an in/out argument: the
  # caller passes in the maximum number of code points that it
  # can receive, and on successful return it will contain the
  # number of code points actually output.  The case_flags array
  # holds input_length boolean values, where nonzero suggests that
  # the corresponding Unicode character be forced to uppercase
  # after being decoded (if possible), and zero suggests that
  # it be forced to lowercase (if possible).  ASCII code points
  # are encoded literally, except that ASCII letters are forced
  # to uppercase or lowercase according to the corresponding
  # uppercase flags.  If case_flags is a null pointer then ASCII
  # letters are left as they are, and other code points are
  # treated as if their uppercase flags were zero.  The return
  # value can be any of the punycode_status values defined above
  # except punycode_bad_input; if not punycode_success, then
  # output_size and output might contain garbage.
  def punycode_encode(input_length, input, case_flags, output_length, output)

    # Initialize the state:

    n = INITIAL_N
    delta = out = 0
    max_out = output_length[0]
    bias = INITIAL_BIAS

    # Handle the basic code points:
    input_length.times do |j|
      if basic(input[j])
        raise PunycodeBigOutput if max_out - out < 2
        output[out] =
          if case_flags
            encode_basic(input[j], case_flags[j])
          else
            input[j]
          end
        out+=1
      # elsif (input[j] < n)
      #   raise PunycodeBadInput
      # (not needed for Punycode with unsigned code points)
      end
    end

    h = b = out

    # h is the number of code points that have been handled, b is the
    # number of basic code points, and out is the number of characters
    # that have been output.

    if b > 0
      output[out] = DELIMITER
      out+=1
    end

    # Main encoding loop:

    while h < input_length
      # All non-basic code points < n have been
      # handled already.  Find the next larger one:

      m = MAXINT
      input_length.times do |j|
        # next if basic(input[j])
        # (not needed for Punycode)
        m = input[j] if (n...m) === input[j]
      end

      # Increase delta enough to advance the decoder's
      # <n,i> state to <m,0>, but guard against overflow:

      raise PunycodeOverflow if m - n > (MAXINT - delta) / (h + 1)
      delta += (m - n) * (h + 1)
      n = m

      input_length.times do |j|
        # Punycode does not need to check whether input[j] is basic:
        if input[j] < n # || basic(input[j])
          delta+=1
          raise PunycodeOverflow if delta == 0
        end

        if input[j] == n
          # Represent delta as a generalized variable-length integer:

          q = delta; k = BASE
          while true
            raise PunycodeBigOutput if out >= max_out
            t = if k <= bias # + TMIN # +TMIN not needed
                  TMIN
                elsif k >= bias + TMAX
                  TMAX
                else
                  k - bias
                end
            break if q < t
            output[out] = encode_digit(t + (q - t) % (BASE - t), false)
            out+=1
            q = (q - t) / (BASE - t)
            k += BASE
          end

          output[out] = encode_digit(q, case_flags && case_flags[j])
          out+=1
          bias = adapt(delta, h + 1, h == b)
          delta = 0
          h+=1
        end
      end

      delta+=1; n+=1
    end

    output_length[0] = out
    return PunycodeSuccess
  end

  # *** Main decode function ***

  # punycode_decode() converts Punycode to Unicode.  The input is
  # represented as an array of ASCII code points, and the output
  # will be represented as an array of Unicode code points.  The
  # input_length is the number of code points in the input.  The
  # output_length is an in/out argument: the caller passes in
  # the maximum number of code points that it can receive, and
  # on successful return it will contain the actual number of
  # code points output.  The case_flags array needs room for at
  # least output_length values, or it can be a null pointer if the
  # case information is not needed.  A nonzero flag suggests that
  # the corresponding Unicode character be forced to uppercase
  # by the caller (if possible), while zero suggests that it be
  # forced to lowercase (if possible).  ASCII code points are
  # output already in the proper case, but their flags will be set
  # appropriately so that applying the flags would be harmless.
  # The return value can be any of the punycode_status values
  # defined above; if not punycode_success, then output_length,
  # output, and case_flags might contain garbage.  On success, the
  # decoder will never need to write an output_length greater than
  # input_length, because of how the encoding is defined.
  def punycode_decode(input_length, input, output_length, output, case_flags)

    # Initialize the state:

    n = INITIAL_N

    out = i = 0
    max_out = output_length[0]
    bias = INITIAL_BIAS

    # Handle the basic code points:  Let b be the number of input code
    # points before the last delimiter, or 0 if there is none, then
    # copy the first b code points to the output.

    b = 0
    input_length.times do |j|
      b = j if delim(input[j])
    end
    raise PunycodeBigOutput if b > max_out

    b.times do |j|
      case_flags[out] = flagged(input[j]) if case_flags
      raise PunycodeBadInput unless basic(input[j])
      output[out] = input[j]
      out+=1
    end

    # Main decoding loop:  Start just after the last delimiter if any
    # basic code points were copied; start at the beginning otherwise.

    in_ = b > 0 ? b + 1 : 0
    while in_ < input_length

      # in_ is the index of the next character to be consumed, and
      # out is the number of code points in the output array.

      # Decode a generalized variable-length integer into delta,
      # which gets added to i.  The overflow checking is easier
      # if we increase i as we go, then subtract off its starting
      # value at the end to obtain delta.

      oldi = i; w = 1; k = BASE
      while true
        raise PunycodeBadInput if in_ >= input_length
        digit = decode_digit(input[in_])
        in_+=1
        raise PunycodeBadInput if digit >= BASE
        raise PunycodeOverflow if digit > (MAXINT - i) / w
        i += digit * w
        t = if k <= bias # + TMIN # +TMIN not needed
              TMIN
            elsif k >= bias + TMAX
              TMAX
            else
              k - bias
            end
        break if digit < t
        raise PunycodeOverflow if w > MAXINT / (BASE - t)
        w *= BASE - t
        k += BASE
      end

      bias = adapt(i - oldi, out + 1, oldi == 0)

      # i was supposed to wrap around from out+1 to 0,
      # incrementing n each time, so we'll fix that now:

      raise PunycodeOverflow if i / (out + 1) > MAXINT - n
      n += i / (out + 1)
      i %= out + 1

      # Insert n at position i of the output:

      # not needed for Punycode:
      # raise PUNYCODE_INVALID_INPUT if decode_digit(n) <= base
      raise PunycodeBigOutput if out >= max_out

      if case_flags
        #memmove(case_flags + i + 1, case_flags + i, out - i)
        case_flags[i + 1, out - i] = case_flags[i, out - i]

        # Case of last character determines uppercase flag:
        case_flags[i] = flagged(input[in_ - 1])
      end

      #memmove(output + i + 1, output + i, (out - i) * sizeof *output)
      output[i + 1, out - i] = output[i, out - i]
      output[i] = n
      i+=1

      out+=1
    end

    output_length[0] = out
    return PunycodeSuccess
  end

  def encode(unicode_string, case_flags=nil)
    input = unicode_string.unpack('U*')
    output = [0] * (ACE_MAX_LENGTH+1)
    output_length = [ACE_MAX_LENGTH]

    punycode_encode(input.size, input, case_flags, output_length, output)

    outlen = output_length[0]
    outlen.times do |j|
      c = output[j]
      unless c >= 0 && c <= 127
        raise Error, "assertion error: invalid output char"
      end
      unless PRINT_ASCII[c]
        raise PunycodeBadInput
      end
      output[j] = PRINT_ASCII[c]
    end

    output[0..outlen].map{|x|x.chr}.join('').sub(/\0+\z/, '')
  end

  def decode(punycode, case_flags=[])
    output = []

    input = punycode.split(//)
    if ACE_MAX_LENGTH*2 < input.size
      raise PunycodeBigOutput
    end
    input.each_with_index do |c, i|
      print_ascii_index = PRINT_ASCII.index(c)
      raise PunycodeBadInput unless print_ascii_index
      input[i] = print_ascii_index
    end

    output_length = [UNICODE_MAX_LENGTH]
    Punycode.punycode_decode(input.length, input, output_length,
                             output, case_flags)
    output.pack('U*')
  end

  UNICODE_MAX_LENGTH = 256
  ACE_MAX_LENGTH = 256

  # The following string is used to convert printable
  # characters between ASCII and the native charset:

  PRINT_ASCII =
    "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n" \
    "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n" \
    " !\"\#$%&'()*+,-./" \
    "0123456789:;<=>?" \
    "@ABCDEFGHIJKLMNO" \
    "PQRSTUVWXYZ[\\]^_" \
    "`abcdefghijklmno" \
    "pqrstuvwxyz{|}~\n"
end

if __FILE__ == $0
  UNICODE_MAX_LENGTH = Punycode::UNICODE_MAX_LENGTH
  ACE_MAX_LENGTH = Punycode::ACE_MAX_LENGTH

  def usage(argv)
    STDERR.puts <<-USAGE
#{argv[0]} -e reads code points and writes a Punycode string.
#{argv[0]} -d reads a Punycode string and writes code points.

Input and output are plain text in the native character set.
Code points are in the form u+hex separated by whitespace.
Although the specification allows Punycode strings to contain
any characters from the ASCII repertoire, this test code
supports only the printable characters, and needs the Punycode
string to be followed by a newline.
The case of the u in u+hex is the force-to-uppercase flag.
    USAGE
    exit(false)
  end

  TOO_BIG = "input or output is too large, recompile with larger limits"
  INVALID_INPUT = "invalid input"
  OVERFLOW = "arithmetic overflow"
  IO_ERROR = "I/O error"

  PRINT_ASCII = Punycode::PRINT_ASCII

  def main(argv)
    case_flags = [0] * UNICODE_MAX_LENGTH

    usage(argv) if argv.size != 2
    usage(argv) if /\A-[de]\z/ !~ argv[1]

    if argv[1][1] == ?e
      input = [0] * UNICODE_MAX_LENGTH
      output = [0] * (ACE_MAX_LENGTH+1)

      # Read the input code points:

      input_length = 0

      STDIN.read.scan(/([uU]\+)([0-9a-fA-F]+)/) do |uplus, codept|
        codept = codept.hex
        if uplus[1] != ?+ || codept > Punycode::MAXINT
          fail(INVALID_INPUT)
        end

        fail(TOO_BIG) if input_length == UNICODE_MAX_LENGTH

        if uplus[0] == ?u
          case_flags[input_length] = false
        elsif uplus[0] == ?U
          case_flags[input_length] = true
        else
          fail(INVALID_INPUT)
        end

        input[input_length] = codept
        input_length+=1
      end

      # Encode:

      output_length = [ACE_MAX_LENGTH]
      begin
        status = Punycode.punycode_encode(input_length, input, case_flags,
                                          output_length, output)
      rescue Punycode::Status::PunycodeBadInput
        fail(INVALID_INPUT)
      rescue Punycode::Status::PunycodeBigOutput
        fail(TOO_BIG)
      rescue Punycode::Status::PunycodeOverflow
        fail(OVERFLOW)
      end
      if status != Punycode::Status::PunycodeSuccess
        fail("assertion error: unknown status")
      end

      # Convert to native charset and output:

      outlen = output_length[0]
      outlen.times do |j|
        c = output[j]
        raise  "assertion error: invalid output char" unless c >= 0 && c <= 127
        unless PRINT_ASCII[c]
          fail(INVALID_INPUT)
        end
        output[j] = PRINT_ASCII[c]
      end

      output = output[0..outlen].map{|x|x.chr}.join('').sub(/\0+\z/, '')
      puts(output)
      exit(true)
    end

    if argv[1][1] == ?d
      #input = [0] * ACE_MAX_LENGTH*2
      #output = [0] * UNICODE_MAX_LENGTH
      output = []

      input = STDIN.gets.split(//)[0,ACE_MAX_LENGTH*2]
      fail(TOO_BIG) if input[-1] != "\n"
      input = input[0...-1]
      input.each_with_index do |c, i|
        print_ascii_index = PRINT_ASCII.index(c)
        fail(INVALID_INPUT) unless print_ascii_index
        input[i] = print_ascii_index
      end

      # Decode:

      output_length = [UNICODE_MAX_LENGTH]
      begin
        status = Punycode.punycode_decode(input.length, input, output_length,
                                          output, case_flags)
      rescue Punycode::Status::PunycodeBadInput
        fail(INVALID_INPUT)
      rescue Punycode::Status::PunycodeBigOutput
        fail(TOO_BIG)
      rescue Punycode::Status::PunycodeOverflow
        fail(OVERFLOW)
      end
      if status != Punycode::Status::PunycodeSuccess
        fail("assertion error: unknown status")
      end

      # Output the result:

      output_length[0].times do |j|
        printf("%s+%04X\n", case_flags[j] ? "U" : "u", output[j])
      end

      exit(true)
    end

    usage(argv)
    raise "not reached"
  end
  main([$0]+ARGV)
end
