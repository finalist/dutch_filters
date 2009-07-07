# DutchFilters
module DutchFilters
  module ActiveRecord
    module Base
      module ClassMethods
        DUTCH_NETCODES = [ '0111', '0113', '0114', '0115', '0117', '0118',
                           '0161', '0162', '0164', '0165', '0166', '0167',
                           '0168', '0172', '0174', '0180', '0181', '0182',
                           '0183', '0184', '0186', '0187', '0222', '0223',
                           '0224', '0226', '0227', '0228', '0229', '0251',
                           '0252', '0255', '0294', '0297', '0299', '0313',
                           '0314', '0315', '0316', '0317', '0318', '0320',
                           '0321', '0341', '0342', '0343', '0344', '0345',
                           '0346', '0347', '0348', '0411', '0412', '0413',
                           '0416', '0418', '0475', '0481', '0485', '0486',
                           '0487', '0488', '0492', '0493', '0495', '0497',
                           '0499', '0511', '0512', '0513', '0514', '0515',
                           '0516', '0517', '0518', '0519', '0521', '0522',
                           '0523', '0524', '0525', '0527', '0528', '0529',
                           '0541', '0543', '0544', '0545', '0546', '0547',
                           '0548', '0561', '0562', '0566', '0570', '0571',
                           '0572', '0573', '0575', '0577', '0578', '0591',
                           '0592', '0593', '0594', '0595', '0594', '0595',
                           '0596', '0597', '0598', '0599', '0800' ]

        # Adds dutch zipcode filter to given attributes
        def filters_dutch_zipcode(*args)
          create_filter_method("filter_dutch_zipcode", args)
        end

        # Adds dutch telephone number filter to given attributes
        def filters_dutch_telephonenumber(*args)
          create_filter_method("filter_dutch_telephonenumber", args)
        end

        private
          def create_filter_method(filter, fields)
            fields = [fields] unless(fields.kind_of?(Array))
            fields.each do |field|
              define_method("#{field}") { send(filter, instance_variable_get("@#{field}")) }
              define_method("#{field}=") { |value| instance_variable_set("@#{field}", send(filter, value)) }
            end
          end
      end

      module InstanceMethods
        private
          def filter_dutch_zipcode(zipcode)
            zipcode = zipcode.upcase.gsub(/[^0-9A-Z]/, '').strip

            if(zipcode.length < 6)
              zipcode
            else
              "#{zipcode[0..3]} #{zipcode[4..5]}"
            end
          end

          def filter_dutch_telephonenumber(number)
            return if(number.nil?)

            # remove all incorrect characters
            number.gsub!(/[^0-9]/, '')
            return nil if(number.strip == '')

            if(number =~ /^06/)
              net = '06'
              member = number[2..-1]
            elsif(self::DUTCH_NETCODES.include?(number[0..3]))
              net = number[0..3]
              member = number[4..-1]
            else
              net = number[0..2]
              member = number[3..-1]
            end

            if(net.length == 3 and member.length == 7)
              "(#{net}) #{member[0..2]} #{member[3..4]} #{member[5..-1]}"
            elsif(net.length == 4 and member.length == 6)
              "(#{net}) #{member[0..1]} #{member[2..3]} #{member[4..-1]}"
            elsif(net == '06')
              "(#{net}) #{member[0..1]} #{member[2..3]} #{member[4..5]} #{member[6..-1]}"
            else
              "(#{net}) #{member}"
            end
          end
      end
    end
  end
end
