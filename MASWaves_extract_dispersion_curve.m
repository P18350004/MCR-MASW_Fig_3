
function [f_curve0,c_curve0,lambda_curve0,f_curve0_up,c_curve0_up,lambda_curve0_up,f_curve0_low,c_curve0_low,lambda_curve0_low] = ...
    MASWaves_extract_dispersion_curve(f,c,A,fmin,fmax,f_receivers,select,up_low_boundary,p)

% Plot 2D dispersion image.
figh = figure;
resolution = 100;
FigWidth = 8; % [cm]
FigHeight = 10; % [cm]
FigFontSize = 14; % [pt]
[fplot,cplot,Aplot] = MASWaves_plot_dispersion_image_2D(f,c,A,fmin,fmax,resolution,FigWidth,FigHeight,FigFontSize);
hold on

% Locate maxima at each frequency
Aabsnorm2 = zeros(size(Aplot));
for i = 1:length(Aplot(:,1))
    Aabsnorm2(i,:) = Aplot(i,:)./max(max(Aplot(i,:)));
end

[f_loc,c_loc]=find(Aabsnorm2==1);

Amax_fvec = zeros(size(f_loc));
Amax_cvec = zeros(size(f_loc));
for i = 1:length(f_loc)
    Amax_fvec(i) = fplot(f_loc(i),1);
    Amax_cvec(i) = cplot(1,c_loc(i));
end

ii = find(Amax_fvec > f_receivers);
Amax_fvec = Amax_fvec(ii);
Amax_cvec = Amax_cvec(ii);

% Sort points
[Amax_fvec_sort,I] = sort(Amax_fvec);
Amax_cvec_sort = Amax_cvec(I);

% Plot maxima on top of dispersion image
plot(Amax_fvec_sort,Amax_cvec_sort,'o','MarkerSize',4,'MarkerFaceColor','k','MarkerEdgeColor','k')

if strcmp(up_low_boundary,'yes')
    % Upper/lower boundaries for fundamental mode dispersion curve
    [f_loc_p,c_loc_p]=find(Aabsnorm2>p/100);
    
    Amax_fvec_p = zeros(size(f_loc_p));
    Amax_cvec_p = zeros(size(f_loc_p));
    for i = 1:length(f_loc_p)
        Amax_fvec_p(i) = fplot(f_loc_p(i),1);
        Amax_cvec_p(i) = cplot(1,c_loc_p(i));
    end
    
    ii = find(Amax_fvec_p > f_receivers);
    Amax_fvec_p = Amax_fvec_p(ii);
    Amax_cvec_p = Amax_cvec_p(ii);
    
    % Sort points
    [Amax_fvec_sort_p,I] = sort(Amax_fvec_p);
    Amax_cvec_sort_p = Amax_cvec_p(I);
    
    Amax_fvec_sort_p_cell = cell(length(unique(Amax_fvec_sort_p)),1);
    Amax_cvec_sort_p_cell = cell(length(unique(Amax_fvec_sort_p)),1);
    f_curve0_up_temp = zeros(length(unique(Amax_fvec_sort_p)),1);
    c_curve0_up_temp = zeros(length(unique(Amax_fvec_sort_p)),1);
    f_curve0_low_temp = zeros(length(unique(Amax_fvec_sort_p)),1);
    c_curve0_low_temp = zeros(length(unique(Amax_fvec_sort_p)),1);
    
    U = unique(Amax_fvec_sort_p);
    for i = 1:length(U)
        Amax_fvec_sort_p_cell{i} = Amax_fvec_sort_p(find(Amax_fvec_sort_p == U(i)));
        Amax_cvec_sort_p_cell{i} = Amax_cvec_sort_p(find(Amax_fvec_sort_p == U(i)));
        f_curve0_up_temp(i) = Amax_fvec_sort_p_cell{i}(end);
        c_curve0_up_temp(i) = Amax_cvec_sort_p_cell{i}(end);
        f_curve0_low_temp(i) = Amax_fvec_sort_p_cell{i}(1);
        c_curve0_low_temp(i) = Amax_cvec_sort_p_cell{i}(1);
    end
    
    % Plot maxima on top of dispersion image
    %plot(Amax_fvec_sort_p,Amax_cvec_sort_p,'o','MarkerSize',1,'MarkerFaceColor','k','MarkerEdgeColor','k')
    %plot(f_curve0_up_temp,c_curve0_up_temp,'o','MarkerSize',4,'MarkerFaceColor','k','MarkerEdgeColor','k')
    %plot(f_curve0_low_temp,c_curve0_low_temp,'o','MarkerSize',4,'MarkerFaceColor','k','MarkerEdgeColor','k')
end

if strcmp(select,'numbers') == 1 || strcmp(select,'both') == 1
    % Label points
    labels = cellstr(num2str([1:length(Amax_fvec_sort)]'));
    text(Amax_fvec_sort, Amax_cvec_sort, labels, 'VerticalAlignment','bottom','HorizontalAlignment','right')
    hold off
    
    % Fundamental mode dispersion curve
    nP0 = input('Fundamental mode dispersion curve: ');
    f_curve0 = Amax_fvec_sort(nP0);
    c_curve0 = Amax_cvec_sort(nP0);
    
    if strcmp(up_low_boundary,'yes')
        f_curve0_up = f_curve0_up_temp(nP0);
        c_curve0_up = c_curve0_up_temp(nP0);
        f_curve0_low = f_curve0_low_temp(nP0);
        c_curve0_low = c_curve0_low_temp(nP0);
    end
    
    if strcmp(select,'both') == 1
        disp('Select additional points for the fundamental mode dispersion curve. Enter to stop selecting points.')
        [f_curve0_add, c_curve0_add] = getpts(figh);
        f_curve0_temp = [f_curve0 ; f_curve0_add];
        c_curve0_temp = [c_curve0 ; c_curve0_add];
        [f_curve0,I] = sort(f_curve0_temp);
        c_curve0 = c_curve0_temp(I);
        
        if strcmp(up_low_boundary,'yes')
            disp('Select additional points for the upper bound dispersion curve. Enter to stop selecting points.')
            [f_curve0_up_add, c_curve0_up_add] = getpts(figh);
            f_curve0_up_temp = [f_curve0_up ; f_curve0_up_add];
            c_curve0_up_temp = [c_curve0_up ; c_curve0_up_add];
            [f_curve0_up,I] = sort(f_curve0_up_temp);
            c_curve0_up = c_curve0_up_temp(I);
            
            disp('Select additional points for the lower bound dispersion curve. Enter to stop selecting points.')
            [f_curve0_low_add, c_curve0_low_add] = getpts(figh);
            f_curve0_low_temp = [f_curve0_low ; f_curve0_low_add];
            c_curve0_low_temp = [c_curve0_low ; c_curve0_low_add];
            [f_curve0_low,I] = sort(f_curve0_low_temp);
            c_curve0_low = c_curve0_low_temp(I);
        end
    end
    
    lambda_curve0 = c_curve0./f_curve0;
    
    if strcmp(up_low_boundary,'yes')
        lambda_curve0_up = c_curve0_up./f_curve0_up;
        lambda_curve0_low = c_curve0_low./f_curve0_low;
    end
end

if strcmp(select,'mouse') == 1
    hold off
    
    % Fundamental mode dispersion curve
    disp('Select the fundamental mode dispersion curve. Enter to stop selecting points.')
    [f_curve0, c_curve0] = getpts(figh);
    lambda_curve0 = c_curve0./f_curve0;
    
    if strcmp(up_low_boundary,'yes')
        disp('Select additional points for the upper bound dispersion curve. Enter to stop selecting points.')
        [f_curve0_up, c_curve0_up] = getpts(figh);
        lambda_curve0_up = c_curve0_up./f_curve0_up;
        
        disp('Select additional points for the lower bound dispersion curve. Enter to stop selecting points.')
        [f_curve0_low, c_curve0_low] = getpts(figh);
        lambda_curve0_low = c_curve0_low./f_curve0_low;
    end
end

if strcmp(up_low_boundary,'no')
    f_curve0_up = [];
    c_curve0_up = [];
    lambda_curve0_up = [];
    f_curve0_low = [];
    c_curve0_low = [];
    lambda_curve0_low = [];
end

end