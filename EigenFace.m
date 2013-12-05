classdef EigenFace
    properties
        UserId
        Eigenvector
        Photos
        Name
    end
    
    methods
        function EF = EigenFace(name)
           EF.Photos = cell(0);
           EF.Name = name;
        end
        
        function obj = addPhoto(obj,im)
            len = length(obj.Photos);
            obj.Photos{len+1} = im;
        end
        
        function obj = set.Eigenvector(obj,ev)
            obj.Eigenvector = ev;
        end
        
        function obj = set.UserId(obj,ID)
            obj.UserId = ID;
        end
        
        function id = get.UserId(obj)
            id = obj.UserId;
        end
       
    end
end
