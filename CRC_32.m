clc;
clear;

% Read message from user
M = input("Enter the initial message: ", 's'); 

% Convert the string message to binary
binary_M = reshape(dec2bin(M, 8).'-'0',1,[]); 

% Removing the least significant bits
index = find(binary_M ~= 0, 1, 'first'); 
binary_M = binary_M(index : end);

% Add 32 zeros to the end of the message
binary_M = [binary_M zeros(1,32)]; 

% Computing the CRC-32 polynomial
G = [1 0 0 0 0 0 0 1 0 0 1 1 0 0 0 0 0 1 0 0 0 1 1 1 0 1 1 0 1 1 0 1 1 1]; 

% Doing polynomial division between the M and G
[q,R] = gfdeconv(flip(binary_M), flip(G));  
R = flip(R);

% Adding zeros to the begining of the remainder to make it equal in size to
% the message
R = [zeros(1, max(0, numel(binary_M)-numel(R))), R];

% Performing binary subtraction to create the new message T
T = gf(binary_M) - gf(R);

% Computing S
[~,S] = deconv(T, G);

% Checking if the remainder is 0
if(~any(S))
 disp ("Dataword '" + (M) + "' accepted");
end

disp(T);

 % Selecting a random bit from T to modify
 random_int = randi(length(T));
 
 % Modifying that bit
 if(T(random_int) == 0)
  T(random_int) = 1;
 else
  T(random_int) = 0;
 end
  % Computing S again but with the modified message this time
 [~,S] = deconv(T, G);
 
 % If the new remainder is not 0, it means that the message was corrupted
 if(any(S))
   disp ("error!!! Dataword discarded");  
 end







