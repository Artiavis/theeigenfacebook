classdef EigenFace
    properties
        Eigenvector
        Photos
        Name
    end
    
    methods
        function EF = EigenFace(name)
           EF.Photos = cell(0);
           EF.Name = name;
        end
        
        function EF = addPhoto(EF,im)
            len = length(EF.Photos);
            EF.Photos{len+1} = im;
        end
        
        function EF = setEigenvector(EF,ev)
            EF.Eigenvector = ev;
        end
    end
end
