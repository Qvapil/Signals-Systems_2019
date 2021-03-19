%THIS CODE WAS WRITTEN FOR GNU OCTAVE

%library with most functions used
pkg load signal

% Step-impulse simulating function
% Input: The b,a coefficients of the system
% Duration of simulation, N (in samples)
function stepzz(b,a,N)
  
  u = ones(1,N);
  y = filter(b,a,u);
  
  figure
  stem(y)
  hold on
  title('Step response')
  xlabel('Time(samples)')
  ylabel('Amplitude')
end

%1.1.a
a=1;
N2=2;
N4=4;
N10=10;
b2=1/(N2+1)*ones(1,N2);
b4=1/(N4+1)*ones(1,N4);
b10=1/(N10+1)*ones(1,N10);

%1.1.b
figure
freqz(b2,a)
title('Frequency response of moving average filter for N=2')
figure
freqz(b4,a)
title('Frequency response of moving average filter for N=4')
figure
freqz(b10,a)
title('Frequency response of moving average filter for N=10')


%1.1.c
figure
zplane(b2,a);
title('Zero-pole diagram of moving average filter for N=2')
figure
zplane(b4,a);
title('Zero-pole diagram of moving average filter for N=4')
figure
zplane(b10,a);
title('Zero-pole diagram of moving average filter for N=10')

%1.2.a
figure
p=[0.68+0.51j 0.68-0.51j]';
z=[1.2 -0.6]';
zplane(z,p);
[b,a]=zp2tf(z,p,1)

%1.2.b
figure
freqz(b,a)


%1.2.c
figure
impz(b,a);
title('Impulse response')
ylabel('Amplitude')
xlabel('Time (samples)')
stepzz(b,a,100);


%1.2.d
p=[0.76+0.57j 0.76-0.57j]';
figure
zplane(z,p);
figure
[b,a]=zp2tf(z,p,1);
freqz(b,a)
stepzz(b,a,100);

p=[0.8+0.6j 0.8-0.6j]';
figure
zplane(z,p);
[b,a]=zp2tf(z,p,1);
stepzz(b,a,100);

p=[0.84+0.63j 0.84-0.63j]';
figure
zplane(z,p);
[b,a]=zp2tf(z,p,1);
stepzz(b,a,100);

%1.2.e
p=[0.68+0.51j 0.68-0.51j]';
[b,a]=zp2tf(z,p,1);
figure
x=gensig('pulse',50,100,1);
y=filter(b,a,x);
stem(y);
title('periodic (50) pulse signal through filter')
figure
x=gensig('pulse',5,100,1);
y=filter(b,a,x);
stem(y);
title('periodic (5) pulse signal through filter')

%1.2.st
p=[0.8j -0.8j];
figure
zplane(z,p);
[b,a]=zp2tf(z,p,1)
figure
freqz(b,a)

%2.1.a
Fs=44100;
[flute,Fs]=audioread('flute_note.wav');
sound(flute, Fs);
[cello,Fs]=audioread('cello_note.wav');
sound(cello, Fs);
[clarinet,Fs]=audioread('clarinet_note.wav');
sound(clarinet, Fs);


%2.1.b
%flper contains the part of flute around 1.5 sec
%starting at 33075 samples and ending 418 samples later
%tfl is time in sec instead of samples and has length almost 0.1 sec
flper=zeros(418,1);
for i=1:1:418;
  flper(i)=flute(i+33075);
endfor
figure
tfl=0:0.00947/418:(0.00947-(0.00947/418));
plot(tfl,flper)
title('Periodic part of flute note')
xlabel('time(sec)')

%celper,tcel are defined similar to flper,tfl
%it contains the part 0.47-0.49 sec
celper=zeros(882,1);
for i=1:1:882;
  celper(i)=cello(i+20127);
endfor
figure
tcel=0:0.02/882:(0.02-(0.02/882));
plot(tcel,celper)
title('Periodic part of cello note')
xlabel('time(sec)')

%clper,tcl are defined similarly
%they represent the part 1.15-1.17 sec
clper=zeros(441,1);
for i=1:1:441;
  clper(i)=clarinet(i+25357);
endfor
figure
tcl=0:0.02/441:(0.02-(0.02/441));
plot(tcl,clper)
title('Periodic part of clarinet note')
xlabel('time(sec)')


%2.1.c
%wfl,wcel,wcl is the normalized fequency axis
%fftshift plots from -pi to pi instead of 0 to 2*pi
figure
flutef=fft(flute);
wfl=2*pi*(-(length(flute))/2:(length(flute))/2-1)/(length(flute));
plot(wfl/pi,abs(fftshift(flutef)))
xlim([-0.3 0.3])
title('Flute in frequency domain')
xlabel('Frequency (radians / \pi)')

figure
cellof=fft(cello);
wcel=2*pi*(-(length(cello))/2:(length(cello))/2-1)/(length(cello));
plot(wcel/pi,abs(fftshift(cellof)))
xlim([-0.3 0.3])
title('Cello in frequency domain')
xlabel('Frequency (radians/ \pi)')

figure
clarinetf=fft(clarinet);
wcl=2*pi*(-(length(clarinet))/2:(length(clarinet))/2-1)/(length(clarinet));
plot(wcl/pi,abs(fftshift(clarinetf)))
xlim([-0.3 0.3])
title('Clarinet in frequency domain')
xlabel('Frequency (radians / \pi)')


%2.1.d
%ltfat for normalize
pkg load ltfat
flutesc=normalize(flute,'peak');
fl1=buffer(flutesc,1000);
fluteenergy=zeros(1,89);
for i=1:1:89
  fluteenergy(i)=0;
  for j=1:1:1000
    fluteenergy(i)=fluteenergy(i)+abs(fl1(j,i))^2;
  endfor
endfor
n=0:length(flutesc)/89:length(flutesc)-length(flutesc)/89;
figure
flenergsc=normalize(fluteenergy,'peak');
%tflute=0:1/Fsfl:length(flutesc)*(1/Fsfl)-1/Fsfl;
plot(0:1:length(flutesc)-1,flutesc,n,flenergsc)
title('Energy of flute signal')
legend('flute','energy')

cellosc=normalize(cello,'peak');
cel1=buffer(cellosc,1000);
celloenergy=zeros(1,45);
for i=1:1:45
  celloenergy(i)=0;
  for j=1:1:1000
    celloenergy(i)=celloenergy(i)+abs(cel1(j,i))^2;
  endfor
endfor
n=0:length(cellosc)/45:length(cellosc)-length(cellosc)/45;
figure
celenergsc=normalize(celloenergy,'peak');
plot(0:1:length(cellosc)-1,cellosc,n,celenergsc)
title('Energy of cello signal')
legend('cello','energy')

clarinetsc=normalize(clarinet,'peak');
cl1=buffer(clarinetsc,1000);
clarinetenergy=zeros(1,89);
for i=1:1:89
  clarinetenergy(i)=0;
  for j=1:1:1000
    clarinetenergy(i)=clarinetenergy(i)+abs(cl1(j,i))^2;
  endfor
endfor
n=0:length(clarinetsc)/89:length(clarinetsc)-length(clarinetsc)/89;;
figure
clenergsc=normalize(clarinetenergy,'peak');
plot(0:1:length(clarinetsc)-1,clarinetsc,n,clenergsc)
title('Energy of clarinet signal')
legend('clarinet','energy')


%2.1.e
[noisycello,Fs]=audioread('cello_note_noisy.wav');
sound(noisycello,Fs);
figure
celnf=fft(noisycello);
wcn=2*pi*(-(length(noisycello))/2:(length(noisycello))/2-1)/(length(noisycello));
plot(wcn/pi,abs(fftshift(celnf)))
xlim([-0.3 0.3])
title('Noisy cello in frequency domain')
xlabel('Frequency (radians / \pi)')


%2.1.st
a=1
N=11
b=(1/N)*ones(1,N);
figure
celclean=filter(b,a,noisycello);
celcleanf=fft(celclean);
wcc=2*pi*(-(length(celclean))/2:(length(celclean))/2-1)/(length(celclean));
plot(wcc/pi,abs(fftshift(celcleanf)));
xlim([-0.3 0.3])
title('Filtered noisy cello in frequency domain')
xlabel('Frequency (radians / \pi)')
sound(celclean,Fs)

N=5
b=(1/N)*ones(1,N);
figure
celclean=filter(b,a,noisycello);
celcleanf=fft(celclean);
wcc=2*pi*(-(length(celclean))/2:(length(celclean))/2-1)/(length(celclean));
plot(wcc/pi,abs(fftshift(celcleanf)));
xlim([-0.3 0.3])
title('Filtered noisy cello in frequency domain')
xlabel('Frequency (radians / \pi)')
sound(celclean,Fs)



%2.1.z
[b,a]=butter(3,[0.0975 0.1]);
figure
cel9=filter(b,a,cello);
t=0:1/Fs:length(cello)*(1/Fs)-1/Fs;
plot(t,cel9)
xlim([0.475 0.48])
title('9th harmonic of cello note')
xlabel('Time(sec)')
figure
cel9f=fft(cel9);
wcc=2*pi*(-(length(cel9))/2:(length(cel9))/2-1)/(length(cel9));
plot(wcc/pi,abs(fftshift(cel9f)));
xlim([-0.2 0.2])
title('9th harmonic of cello note in frequency domain')
xlabel('Frequency (radians / \pi)')

[b,a]=butter(3,[0.064 0.067]);
figure
cel6=filter(b,a,cello);
t=0:1/Fs:length(cello)*(1/Fs)-1/Fs;
plot(t,cel6)
xlim([0.475 0.48])
title('6th harmonic of cello note')
xlabel('Time(sec)')
figure
cel6f=fft(cel6);
wcc=2*pi*(-(length(cel6))/2:(length(cel6))/2-1)/(length(cel6));
plot(wcc/pi,abs(fftshift(cel6f)));
xlim([-0.2 0.2])
title('6th harmonic of cello note in frequency domain')
xlabel('Frequency (radians / \pi)')

%plot the harmonics
figure
plot(0:1:length(cellof)-1,abs(fftshift(cellof)),0:1:length(cel6f)-1,abs(fftshift(cel6f)),0:1:length(cel9f)-1,abs(fftshift(cel9f)))
xlim([18000 26000])
title('Cello note in frequency domain')
legend('Cello note','6th harmonic frequency','9th harmonic frequency')

%2.2.a
%part around 1.5sec
flper=zeros(836,1);
for i=1:1:836;
  flper(i)=flute(i+33075);
endfor
tfl=0:0.019/836:0.019-0.019/836;
figure
plot(tfl,flper)
title('Periodic part of flute note (10 periods)')
xlabel('time(sec)')

%2.2.b
figure
flperf=fft(flper);
wflp=2*pi*(-(length(flper))/2:(length(flper))/2-1)/(length(flper));
stem(wflp/pi,abs(fftshift(flperf)))
xlim([-0.3 0.3])
title('Periodic part of flute note in frequency domain')
xlabel('Frequency (radians / \pi)')
c=[25.506 17.78 12.98 2.278 2.75 0.918 0.728 0.4832 0.179 0.18]./25.506;

%2.2.c
figure
stem(wflp/pi,angle(fftshift(flperf)))
xlim([-0.3 0.3])
title('Angle of dft of flute')
ph=[-2.014 2.756 0.88 1.8032 0.963 -2.5 -2.817 -1.07 -0.25963 0.513];

%2.2.d
f1=0.023912;
t=0:1:836-1;
x1=c(1).*cos(pi*f1*t+ph(1));
x2=c(2).*cos(pi*2*f1*t+ph(2));
x3=c(3).*cos(pi*3*f1*t+ph(3));
x4=c(4).*cos(pi*4*f1*t+ph(4));
x5=c(5).*cos(pi*5*f1*t+ph(5));
x6=c(6).*cos(pi*6*f1*t+ph(6));
x7=c(7).*cos(pi*7*f1*t+ph(7));
x8=c(8).*cos(pi*8*f1*t+ph(8));
x9=c(9).*cos(pi*9*f1*t+ph(9));
x10=c(10).*cos(pi*10*f1*t+ph(10));
recons=x1+x2+x3+x4+x5+x6+x7+x8+x9+x10;



%2.2.e
reconssc=normalize(recons,'peak');
flpersc=normalize(flper,'peak');
figure
plot(t,flpersc,t,reconssc)
title('Original and reconstructed flute signal (10 harmonics)')
legend('Normalized flute signal','Normalized reconstructed signal')
figure
plot(t,flpersc,t,normalize(x1+x2+x3+x4+x5,'peak'),t,normalize(x1,'peak'))
title('Original and reconstructed flute signal')
legend('Normalized flute signal','Normalized reconstructed signal (5 harmonics)','Normalized reconstructed signal (1 harmonic)')
sound(recons,Fs)

%2.2.st
wavwrite(recons,Fs,'reconstructed.wav');
