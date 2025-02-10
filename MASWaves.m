clear all
close all
clc
tic
%% DATA INPUT 
Filename = 'Shot4_G1_12_0.3s.dat'; % for generating Fig. 3a
% Filename = 'Shot4_G13_24_0.3s.dat';  % for generating Fig. 3b
HeaderLines = 7;
fs = 4000; % Hz
N = 12;
x1 = 5; % m
dx = 1; % m
Direction = 'forward';

[u,t,Tmax,L,x] = MASWaves_read_data(Filename,HeaderLines,fs,N,dx,x1,Direction);

%% PLOT DATA 
du = 1/75;
FigWidth = 6; % cm
FigHeight = 8; % cm
FigFontSize = 8; % pt

figure
MASWaves_plot_data(u,N,dx,x1,L,t,Tmax,du,FigWidth,FigHeight,FigFontSize)

%% DISPERSION 
cT_min = 0; % m/s
cT_max = 3000; % m/s
delta_cT = 50; % m/s

[f,c,A] = MASWaves_dispersion_imaging(u,N,x,fs,cT_min,cT_max,delta_cT);

%% VELOCITY SPECTRA 2D
resolution = 100; 
fmin = 0; % Hz
fmax = 50; % Hz
FigWidth = 7; % cm
FigHeight = 7; % cm
FigFontSize = 8; % pt
figure
[fplot,cplot,Aplot] = MASWaves_plot_dispersion_image_2D(f,c,A,fmin,fmax,...
    resolution,FigWidth,FigHeight,FigFontSize);

%% VELOCITY SPECTRA 3D
fmin = 1; % Hz
fmax = 50; % Hz
FigWidth = 10; % cm
FigHeight = 10; % cm
FigFontSize = 8; % pt
figure
[fplot,cplot,Aplot] = MASWaves_plot_dispersion_image_3D(f,c,A,fmin,fmax,...
    FigWidth,FigHeight,FigFontSize);

%% SELECT POINTS 
f_receivers = 4.5; % Hz
 select = 'numbers';
% select = 'both';
up_low_boundary = 'no'; 
p = 95; % Percentage
[f_curve0,c_curve0,lambda_curve0,...
    f_curve0_up,c_curve0_up,lambda_curve0_up,...
    f_curve0_low,c_curve0_low,lambda_curve0_low] = ...
    MASWaves_extract_dispersion_curve(f,c,A,fmin,fmax,f_receivers,...
    select,up_low_boundary,p);



save Result.mat
clock
toc

