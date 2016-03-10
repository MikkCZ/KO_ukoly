function ukol01()
    load('data.mat','oldStorage');
    %oldStorage=[1 2 3 4 5 6 7 8 9 3 6 5 3 4 2 7 4; 2 3 4 5 6 4 7 8 9 3 5 2 6 7 8 4 5; 4 5 7 8 9 3 6 4 6 8 4 5 2 7 4 5 4; 3 3 3 8 9 3 6 4 6 8 4 5 2 7 7 4 -1; 6 4 4 5 6 3 7 5 7 8 9 3 5 3 7 -1 0; 6 4 4 5 6 3 7 8 6 9 3 6 5 3 4 -1 4; 1 2 3 4 6 4 4 5 6 6 9 3 6 5 3 -1 0; 1 2 3 4 6 0 0 5 4 4 5 6 6 9 3 -1 0]
    cleanedData = cleanData(oldStorage);
    prices = countPrices(cleanedData);
    g = graph(prices);
    tree = spanningtree(g);
    graphedit(tree);
    edges = cell2mat(tree.edl);
    sum(edges(:,3))
end

function cleanedData = cleanData(oldStorage)
    [rows, cols] = size(oldStorage);
    cleanedData = double([]);
    for i = 1:rows
        row = oldStorage(i,:);
        cleanedRow = cleanRow(row);
        cleanedData{i} = cleanedRow;
    end
end

function cleanedRow = cleanRow(row)
    cols = length(row);
    cleanedRow = double([]);
    for i = 1:cols
        if(row(1,i)==-1)
            break;
        else
            cleanedRow(i) = row(1,i);
        end
    end
end

function prices = countPrices(cleanedData)
    [rows, cols] = size(cleanedData);
    prices = zeros(rows,rows);
    for i = 1:cols
        for j = 1:cols
            if(i==j)
                prices(i,j) = 1000000;
            else
                prices(i,j) = levenshtein(cleanedData{i}, cleanedData{j});
            end
        end
    end
end

function distance = levenshtein(s, t)
    % with help of https://en.wikipedia.org/wiki/Wagner%E2%80%93Fischer_algorithm
    m = length(s);
    n = length(t);
    d = zeros(m+1, n+1);
    for i=1:m+1
        d(i, 1) = i-1;
    end
    for j=1:n+1
        d(1, j) = j-1;
    end
    
    for j = 1:n
        for i = 1:m
            if (s(i)==t(j))
                % match
                d(i+1, j+1) = d(i, j);
            else
                % (deletion, insertion, substitution)
                d(i+1, j+1) = minThree( d(i,j+1)+1, d(i+1,j)+1, d(i,j)+1 );
            end
        end
    end
    
    distance = d(m+1, n+1);
end

function min = minThree(x, y, z)
    min = x;
    if(y<min)
        min = y;
    end
    if(z<min)
        min = z;
    end
end