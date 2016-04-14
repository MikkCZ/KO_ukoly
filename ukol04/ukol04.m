function ukol04()
    load('projection_data_ko.mat');
    [~,n1] = size(sumC);
    [~,n2] = size(sumR);
    I = zeros(n1,n2);
    lastI = I;
    
    countOfIterations = 5;
    pairs = {'CR', 'CD', 'CA', 'RD', 'RA', 'AD'};
    [~,numOfPairs] = size(pairs);
    for ic = 1:countOfIterations;
        disp(ic)
        pairNum = 0;
        for pair = pairs
            disp(pair)
            pairNum = pairNum+1;
            switch(char(pair))
                case 'CR'
                    I = pairCR(I, sumC, sumR);
                case 'CA'
                    I = pairCA(I, sumC, sumA);
                case 'CD'
                    I = pairCD(I, sumC, sumD);
                case 'RA'
                    I = pairRA(I, sumR, sumA);
                case 'RD'
                    I = pairRD(I, sumR, sumD);
                case 'AD'
                    I = pairAD(I, sumA, sumD, sumR);
            end
            updateFigure(I, countOfIterations, numOfPairs, numOfPairs*(ic-1)+pairNum);
        end
        if isequal(I,lastI)
            disp(ic)
            break;
        else
            lastI = I;
        end
    end
end

function [n1,n2,l,b] = common(sumP1,sumP2)
    [~,n1] = size(sumP1);
    [~,n2] = size(sumP2);
    l = zeros(n1+n2,n1+n2);
    b = [sumP1 -sumP2]';
end

function I = pairCR(I, sumC, sumR)
    [n1,n2,l,b] = common(sumC, sumR);
    tmpC = ones(n1,n2)-I';
    tmpU = ones(n1,n2);
    c = [zeros(n1,n1) tmpC;
        zeros(n2,n1) zeros(n2,n2)];
    u = [zeros(n1,n1) tmpU;
        zeros(n2,n1) zeros(n2,n2)];
    F = mincost(c,l,u,b);
    I = F(1:n1,n1+1:n1+n2)';
end

function I = pairCA(I, sumC, sumA)
    [n1,n2,l,b] = common(sumC, sumA);
    tmpC = zeros(n1,n2);
    tmpU = zeros(n1,n2);
    for i=1:n1
        for j=i:i+n1-1
            k_ = j-i+1;
            l_ = i;
            tmpC(i,j) = 1 - I(k_,l_);
            tmpU(i,j) = 1;
        end
    end
    c = [zeros(n1,n1) tmpC;
        zeros(n2,n1) zeros(n2,n2)];
    u = [zeros(n1,n1) tmpU;
        zeros(n2,n1) zeros(n2,n2)];
    F = mincost(c,l,u,b);
    for i=1:n1
        for j=i:i+n1-1
            k_ = j-i+1;
            l_ = i;
            I(k_,l_) = F(i,j+n1);
        end
    end
end

function I = pairCD(I, sumC, sumD)
    [n1,n2,l,b] = common(sumC, sumD);
    tmpC = zeros(n1,n2);
    tmpU = zeros(n1,n2);
    for i=1:n1
        for j=i:i+n1-1
            k_ = n1-(j-i);
            l_ = i;
            tmpC(i,j) = 1 - I(k_,l_);
            tmpU(i,j) = 1;
        end
    end
    c = [zeros(n1,n1) tmpC;
        zeros(n2,n1) zeros(n2,n2)];
    u = [zeros(n1,n1) tmpU;
        zeros(n2,n1) zeros(n2,n2)];
    F = mincost(c,l,u,b);
    for i=1:n1
        for j=i:i+n1-1
            k_ = n1-(j-i);
            l_ = i;
            I(k_,l_) = F(i,j+n1);
        end
    end
end

function I = pairRA(I, sumR, sumA)
    [n1,n2,l,b] = common(sumR, sumA);
    tmpC = zeros(n1,n2);
    tmpU = zeros(n1,n2);
    for i=1:n1
        for j=i:i+n1-1
            k_ = i;
            l_ = j-(i-1);
            tmpC(i,j) = 1 - I(k_,l_);
            tmpU(i,j) = 1;
        end
    end
    c = [zeros(n1,n1) tmpC;
        zeros(n2,n1) zeros(n2,n2)];
    u = [zeros(n1,n1) tmpU;
        zeros(n2,n1) zeros(n2,n2)];
    F = mincost(c,l,u,b);
    for i=1:n1
        for j=i:i+n1-1
            k_ = i;
            l_ = j-(i-1);
            I(k_,l_) = F(i,j+n1);
        end
    end
end

function I = pairRD(I, sumR, sumD)
    [n1,n2,l,b] = common(sumR, sumD);
    tmpC = zeros(n1,n2);
    tmpU = zeros(n1,n2);
    c = [zeros(n1,n1) tmpC;
        zeros(n2,n1) zeros(n2,n2)];
    u = [zeros(n1,n1) tmpU;
        zeros(n2,n1) zeros(n2,n2)];
    for i=1:n1
        for j=i:i+n1-1
            k_ = i;
            l_ = j-(i-1);
            c(i,j-2*(i-1)+n2) = 1 - I(k_,l_);
            u(i,j-2*(i-1)+n2) = 1;
        end
    end
    F = mincost(c,l,u,b);
    for i=1:n1
        for j=i:i+n1-1
            k_ = i;
            l_ = j-(i-1);
            I(k_,l_) = F(i,j-2*(i-1)+n2);
        end
    end
end

function I = pairAD(I, sumA, sumD, sumR)
    [n1,n2,l,b] = common(sumD, sumA);
    [~,imgN] = size(sumR);
    tmpC = zeros(n1,n2);
    tmpU = zeros(n1,n2);
    c = [zeros(n1,n1) tmpC;
        zeros(n2,n1) zeros(n2,n2)];
    u = [zeros(n1,n1) tmpU;
        zeros(n2,n1) zeros(n2,n2)];
    for k_=1:imgN
        for l_=1:imgN
            i = imgN-k_+l_;
            j = k_+l_+n1-1;
            c(i,j) = 1 - I(k_,l_);
            u(i,j) = 1;
        end
    end
    F = mincost(c,l,u,b);
    for k_=1:imgN
        for l_=1:imgN
            i = imgN-k_+l_;
            j = k_+l_+n1-1;
            I(k_,l_) = F(i,j);
        end
    end
end

function F = mincost(c,l,u,b)
    G = graph;
    F = G.mincostflow(c,l,u,b);
end

function updateFigure(I, rows, cols, order)
    subplot(rows,cols,order);
    imagesc(logical(I));
	colormap(gray);
	axis off;
    axis square;
	drawnow;
end
