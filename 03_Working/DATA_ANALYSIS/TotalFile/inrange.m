function [OutputArray] = inrange(InputArray,min,max)
    first = double(InputArray>min);
    InputArray = first.*InputArray;
    second = double(InputArray < max);
    InputArray = second.*InputArray;
    OutputArray = InputArray;
end