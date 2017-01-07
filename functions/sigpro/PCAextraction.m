function [PCAdata] = PCAextraction(data,variance)
%%
A = [];
for ch=1:size(data,3);
    A = [A;data(:,:,ch)];
end
A = normalizeFeatures(A);
[U S] = performPCA(A);

for ch=1:size(data,3)
    clear A;
    A(:,:)=normalizeFeatures(data(:,:,ch));
    %[U S] = performPCA(A);
    K = findK(S, variance);
    switch ch
        case 1
            PCAdata.ch1 = reducedFeatures(A, U, K);
        case 2
            PCAdata.ch2 = reducedFeatures(A, U, K);
        case 3
            PCAdata.ch3 = reducedFeatures(A, U, K);
        case 4
            PCAdata.ch4 = reducedFeatures(A, U, K);
        case 5
            PCAdata.ch5 = reducedFeatures(A, U, K);
        case 6
            PCAdata.ch6 = reducedFeatures(A, U, K);
        case 7
            PCAdata.ch7 = reducedFeatures(A, U, K);
        case 8
            PCAdata.ch8 = reducedFeatures(A, U, K);
        case 9
            PCAdata.ch9 = reducedFeatures(A, U, K);
        case 10
            PCAdata.ch10 = reducedFeatures(A, U, K);
        case 11
            PCAdata.ch11 = reducedFeatures(A, U, K);
        case 12
            PCAdata.ch12 = reducedFeatures(A, U, K);
        case 13
            PCAdata.ch13 = reducedFeatures(A, U, K);
        case 14
            PCAdata.ch14 = reducedFeatures(A, U, K);
    end
end
end
