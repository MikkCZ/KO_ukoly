function ukol02() %45
    sense = 1; %sense of optimization: 1=minimization, -1=maximization
    b = [6 6 6 6 6 8 9 12 18 22 25 21 21 20 18 21 21 24 24 18 18 18 12 8]';
    b = [b;-b];
    A = generateA();
    [c, ctype, lb, ub, vartype] = generateOther();
    
    %optimization parameters
    schoptions=schoptionsset('ilpSolver','glpk','solverVerbosity',2);
    %call command for ILP
    [xmin,fmin,status,extra] = ilinprog(schoptions,sense,c,A,b,ctype,lb,ub,vartype);
    
    %show the solution
    if(status==1)
        disp('Solution: '); disp(xmin)
        disp('Objective function: '); disp(sum(xmin(1:24)))
        figure('position', [0, 0, 1300, 650]);
        bGraph = bar([b(1:24) A(1:24,1:24)*xmin(1:24)],0.5);
        bGraph(1).FaceColor = 'green';
        bGraph(2).FaceColor = 'magenta';
    else
        disp('No feasible solution found!');
    end;
end

function A = generateA()
    days = 24;
    shift = 8;
    A = zeros(days,2*days);
    for i=1:days
        for j=1:days
            if i<=(shift-1)
                if j<=i || j>=i+(days-(shift-1))
                    A(i,j) = 1;
                end
            else
                if j>=i-(shift-1) && j<=i
                    A(i,j) = 1;
                end
            end
        end
    end
    A = [A;-A];
    for i=1:days
        A(i,i+days) = -1;
        A(i+days,i+days) = -1;
    end
end

function [c, ctype, lb, ub, vartype] = generateOther()
    days = 24;
    c = [zeros(1,days) ones(1,days)]; %kriterialni fce c'x
    ctype = char(zeros(2*days,1));
    lb = zeros(2*days,1); %lower bound of the variables
    ub = zeros(2*days,1);
    vartype = char(zeros(2*days,1));
    for i=1:2*days
        ctype(i) = 'L'; %constraint type: 'E'="=", 'L'="<=", 'G'=">="
        ub(i) = 1000; %upper bound of the variables
        vartype(i) = 'I'; %variable type: 'C'=continuous, 'I'=integer
    end
end