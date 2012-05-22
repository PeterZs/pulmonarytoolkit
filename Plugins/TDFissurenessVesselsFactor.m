classdef TDFissurenessVesselsFactor < TDPlugin
    % TDFissurenessVesselsFactor. Plugin to detect fissures using distance
    %     transform from blood vessels.
    %
    %     This is a plugin for the Pulmonary Toolkit. Plugins can be run using 
    %     the gui, or through the interfaces provided by the Pulmonary Toolkit.
    %     See TDPlugin.m for more information on how to run plugins.
    %
    %     Plugins should not be run directly from your code.
    %
    %     This is an intermediate stage towards lobar segmentation.
    %
    %     TDFissurenessVesselsFactor computes the component of the fissureness
    %     generated using analysis of distance transform from blood vessels,
    %     which are segmented using a threshold applied to vesselness.
    %
    %     For more information, see 
    %     [Doel et al., Pulmonary lobe segmentation from CT images using
    %     fissureness, airways, vessels and multilevel B-splines, 2012]
    %
    %
    %     Licence
    %     -------
    %     Part of the TD Pulmonary Toolkit. http://code.google.com/p/pulmonarytoolkit
    %     Author: Tom Doel, 2012.  www.tomdoel.com
    %     Distributed under the GNU GPL v3 licence. Please see website for details.
    %

    properties
        ButtonText = 'Fissureness <BR>(Vessels part)'
        ToolTip = 'The part of the fissureness filter which uses distance from points of high vesselness'
        Category = 'Fissures'

        AllowResultsToBeCached = true
        AlwaysRunPlugin = false
        PluginType = 'ReplaceOverlay'
        HidePluginInDisplay = false
        FlattenPreviewImage = false
        TDPTKVersion = '1'
        ButtonWidth = 6
        ButtonHeight = 2
        GeneratePreview = true
    end
    
    methods (Static)
        function results = RunPlugin(dataset, ~)
            
            % Get the mask for the lung parenchyma
            lung_mask = dataset.GetResult('TDLeftAndRightLungs');
            
            % Get the vesselness
            vesselness = dataset.GetResult('TDVesselness');
            
            % Threshold vesselness and compute distance transform
            vesselness_threshold = 20;
            vesselness = bwdist((vesselness.RawImage > vesselness_threshold) | ~(lung_mask.RawImage > 0));
            
            % Compute image based on distance transform
            % ToDo: alpha should take into account the voxel size
            alpha = 4;
            
            vesselness = 1 - exp((-(vesselness).^2)./(2*alpha^2));
            
            % Store in results
            results = lung_mask.BlankCopy;            
            results.ChangeRawImage(100*vesselness.*single(lung_mask.RawImage > 0));
            results.ImageType = TDImageType.Scaled;
        end
    end
end