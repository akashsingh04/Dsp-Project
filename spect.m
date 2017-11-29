function [S, F, T] = spect(file)
    [y,fs]= audioread(file);
    %iptsetpref('ImshowAxesVisible','on')
    framelen_samples = (20/1000) * fs;
    noverlap = 0.5 * framelen_samples;
    NFFT = 2^nextpow2(framelen_samples);
    [S, F, T] = spectrogram(y, hamming(framelen_samples), floor(noverlap), NFFT, fs, 'yaxis'); ylim([0 5]);
end