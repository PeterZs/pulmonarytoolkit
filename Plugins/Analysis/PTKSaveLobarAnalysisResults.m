classdef PTKSaveLobarAnalysisResults < PTKPlugin
    % PTKSaveLobarAnalysisResults. Plugin for performing analysis of lobe regions,
    % including airway, emphysema and volume analysis
    %
    %     This is a plugin for the Pulmonary Toolkit. Plugins can be run using 
    %     the gui, or through the interfaces provided by the Pulmonary Toolkit.
    %     See PTKPlugin.m for more information on how to run plugins.
    %
    %     Plugins should not be run directly from your code.
    %
    %
    %     Licence
    %     -------
    %     Part of the TD Pulmonary Toolkit. https://github.com/tomdoel/pulmonarytoolkit
    %     Author: Tom Doel, 2013.  www.tomdoel.com
    %     Distributed under the GNU GPL v3 licence. Please see website for details.
    %

    properties
        ButtonText = 'Lobar analysis'
        ToolTip = 'Performs density analysis over lungs and lobes'
        Category = 'CT regional'
        Mode = 'Analysis'
        Visibility = 'Dataset'

        Context = PTKContextSet.LungROI
        AllowResultsToBeCached = false
        AlwaysRunPlugin = true
        PluginType = 'DoNothing'
        HidePluginInDisplay = false
        FlattenPreviewImage = false
        PTKVersion = '2'
        ButtonWidth = 6
        ButtonHeight = 2
        GeneratePreview = false
        
        Icon = 'lobe_analysis.png'
        Location = 4
    end
    
    methods (Static)
        function results = RunPlugin(dataset, context, reporting)
            image_info = dataset.GetImageInfo;
            uid = image_info.ImageUid;
            patient_name = dataset.GetPatientName;

            contexts = {PTKContextSet.Lungs, PTKContextSet.SingleLung, PTKContextSet.Lobe};
            results = dataset.GetResult('PTKDensityAnalysis', contexts);
            
            table = PTKConvertMetricsToTable(results, patient_name, uid, reporting);
            
            dataset.SaveTableAsCSV('PTKSaveLobarAnalysisResults', 'Lobar analysis', 'LobarResults', 'Analysis for lung and lobar regions', table, MimResultsTable.PatientDim, MimResultsTable.ContextDim, MimResultsTable.MetricDim, []);
        end

        function enabled = IsEnabled(gui_app)
            enabled = gui_app.IsDatasetLoaded() && gui_app.IsCT();
        end
        
        function is_selected = IsSelected(gui_app)
            is_selected = false;
        end        
    end
end