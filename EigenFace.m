classdef EigenFace
    properties
        Eigenvector
        Picture
        Name
    end
    
    methods
        % Dummy constructor for testing objects
        function EF = EigenFace(eigenvector, image, name)
           EF.Eigenvector = eigenvector;
           EF.Picture = image;
           EF.Name = name;
        end
    end
end