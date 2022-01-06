[eeg, freq, tm] = rdsamp('database/S002/S002R01.edf');
[B,A] = butter(2,0.005);
eeg = eeg(:,1:end-1);
eeg_out = eeg;
Fp1 = eeg(:,22);
Fp2 = eeg(:,24);
Fp1 = filter(B,A,Fp1);
Fp2 = filter(B,A,Fp2);
avg_stddev = mean(std(eeg));
Fp1_avg=mean(Fp1);
Fp2_avg=mean(Fp2);
Fp1_std = std(Fp1);
for i=1:length(Fp1)
    avg1(i)=(Fp1(i)+Fp2(i))/2;
end
for ix=1:length(eeg(1,:))
    tempa = filter(B,A,eeg(:,ix))-(avg1)';
    tstd = std(tempa);
    tmean = mean(tempa);
    for j=1:length(tempa)
        if abs(enka(j))>tstd*3
            tempa(j)=tmean;
        end
    end
    eeg_out(:,ix)=tempa;
end
subplot(15,1,1);
plot([eeg(:,32) eeg_out(:,32)])
subplot(15,1,2);
plot([eeg(:,34) eeg_out(:,34)])
subplot(15,1,3);
plot([eeg(:,36) eeg_out(:,36)])
subplot(15,1,4);
plot([eeg(:,1) eeg_out(:,1)])
subplot(15,1,5);
plot([eeg(:,3) eeg_out(:,3)])
subplot(15,1,6);
plot([eeg(:,5) eeg_out(:,5)])
subplot(15,1,7);
plot([eeg(:,9) eeg_out(:,9)])
subplot(15,1,8);
plot([eeg(:,11) eeg_out(:,11)])
subplot(15,1,9);
plot([eeg(:,13) eeg_out(:,13)])
subplot(15,1,10);
plot([eeg(:,15) eeg_out(:,15)])
subplot(15,1,11);
plot([eeg(:,17) eeg_out(:,17)])
subplot(15,1,12);
plot([eeg(:,19) eeg_out(:,19)])
subplot(15,1,13);
plot([eeg(:,21) eeg_out(:,21)])
subplot(15,1,14);
plot([eeg(:,49) eeg_out(:,49)])
subplot(15,1,15);
plot([eeg(:,53) eeg_out(:,53)])


