function seminar3() %55
    sense = 1; %sense of optimization: 1=minimization, -1=maximization
    b = [6 6 6 6 6 8 9 12 18 22 25 21 21 20 18 21 21 24 24 18 18 18 12 8]';
    A = generateA();
    [c, ctype, lb, ub, vartype] = generateOther();
    
    %optimization parameters
    schoptions=schoptionsset('ilpSolver','glpk','solverVerbosity',2);
    %call command for ILP
    [xmin,fmin,status,extra] = ilinprog(schoptions,sense,c,A,b,ctype,lb,ub,vartype);
    
    %show the solution
    if(status==1)
        disp('Solution: '); disp(xmin)
        disp('Objective function: '); disp(fmin)
        figure('position', [0, 0, 1300, 650]);
        axis([1 24 0 40]);
        bGraph = bar([b A*xmin],0.5);
        bGraph(1).FaceColor = 'green';
        bGraph(2).FaceColor = 'yellow';
    else
        disp('No feasible solution found!');
    end;
end

function A = generateA()
    days = 24;
    A = zeros(days,days);
    for i=1:24
        for j=1:24
            if i<=7
                if j<=i || j>=i+17
                    A(i,j) = 1;
                end
            else
                if j>=i-7 && j<=i
                    A(i,j) = 1;
                end
            end
        end
    end
end

function [c, ctype, lb, ub, vartype] = generateOther()
    days = 24;
    c = ones(1,days); %kriterialni fce c'x
    ctype = char(zeros(days,1));
    lb = zeros(days,1); %lower bound of the variables
    ub = zeros(days,1);
    vartype = char(zeros(days,1));
    for i=1:days
        ctype(i) = 'G'; %constraint type: 'E'="=", 'L'="<=", 'G'=">="
        ub(i) = 1000; %upper bound of the variables
        vartype(i) = 'I'; %variable type: 'C'=continuous, 'I'=integer
    end
end