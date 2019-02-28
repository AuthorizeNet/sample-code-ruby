# This is a program to compute TransHash for a given Transaction
# Neccessary paramters :- SignatureKey,ApiLoginId, TransId for the Transaction,Amount Transacted
# For more details regarding implementation please visit For more details please visit https://developer.authorize.net/support/hash_upgrade/?utm_campaign=19Q2%20MD5%20Hash%20EOL%20Partner&utm_medium=email&utm_source=Eloqua for implementation details

require 'openssl'

#SignatureKey is obtained from MINT interface
signatureKey='14B9609FFE2378449B3C0886046DD3B0F20DF12DEB758E48B5FFE1B5875615F0D2A50F7DDB1EAC417EBF76A1FAC374079793650AA493CE127601CB0960938E82';
transId="60115446835";
apiLogin = "5T9cRn9FK";
amount = "10.00";

textToHash="^"+apiLogin+"^"+transId+"^"+amount+"^";
puts signatureKey;
puts textToHash;

def calculate_TransHashSha512(signatureKey,textToHash)
        if(!signatureKey || signatureKey.length == 0)
            raise "Signature key cannot be null or empty";
        end
        if(!textToHash || textToHash.length == 0)
            raise 'textToHash  cannot be null or empty';
        end
        if(signatureKey.length<2 || signatureKey.length%2!=0)
            raise 'Signature Key cannot be less than 2 or odd';
        end
        digest = OpenSSL::Digest.new('sha512')
        return OpenSSL::HMAC.hexdigest(digest, [signatureKey].pack('H*'), textToHash).upcase
end

transHashSha512=calculate_TransHashSha512(signatureKey,textToHash)
puts transHashSha512
end
