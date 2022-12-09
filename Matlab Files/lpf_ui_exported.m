classdef lpf_ui_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        LPFUIFigure              matlab.ui.Figure
        UIAxes                   matlab.ui.control.UIAxes
        CancelButton             matlab.ui.control.Button
        ApplyButton              matlab.ui.control.Button
        TabGroup                 matlab.ui.container.TabGroup
        MedianTab                matlab.ui.container.Tab
        AverageTab               matlab.ui.container.Tab
        ParameterEditFieldLabel  matlab.ui.control.Label
        ParameterEditField       matlab.ui.control.NumericEditField
    end

    
    properties (Access = private)
        mainApp; % Main App Object
        image;
        tempImage;
        
        slider1;
        number1;
    end
    
    methods (Access = private)
        
        function updateCanva(app, image)            
            title(app.UIAxes, []);
            xlabel(app.UIAxes, []);
            ylabel(app.UIAxes, []);
            app.UIAxes.XAxis.TickLabels = {};
            app.UIAxes.YAxis.TickLabels = {};
            
            I = imshow(image, 'parent', app.UIAxes);
            
            app.UIAxes.XAxis.TickLabels = {};
            app.UIAxes.YAxis.TickLabels = {};
            
            app.UIAxes.XLim = [0 I.XData(2)];
            app.UIAxes.YLim = [0 I.YData(2)];
            
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, mainApp)
            app.mainApp = mainApp;
            
            app.image = app.mainApp.tempImage;
            
            app.tempImage = rgb2gray(app.image);
            app.tempImage = imclearborder(medfilt2(app.tempImage));
            updateCanva(app, app.tempImage);
        end

        % Selection change function: TabGroup
        function TabGroupSelectionChanged(app, event)
            selectedTab = app.TabGroup.SelectedTab;
            
            if selectedTab.Title == "Median"
                disp('Running LowPass as Median, Please Wait')
                app.tempImage = rgb2gray(app.image);
                app.tempImage = imclearborder(medfilt2(app.tempImage));
                disp('Finished!');
                updateCanva(app, app.tempImage);
            end
        end

        % Callback function
        function Slider_2ValueChanged(app, event)
            value = app.Slider_2.Value;
            
            f = fspecial('average', value);
            app.tempImage = imfilter(app.tempImage, f);
            updateCanva(app, app.tempImage);
        end

        % Button pushed function: CancelButton
        function CancelButtonPushed(app, event)
            app.delete()
        end

        % Button pushed function: ApplyButton
        function ApplyButtonPushed(app, event)
            app.mainApp.tempImage = app.tempImage;
            app.mainApp.updateCanvaImage(app.mainApp.tempImage);
            app.delete();
        end

        % Value changed function: ParameterEditField
        function ParameterEditFieldValueChanged(app, event)
            value = app.ParameterEditField.Value;
            disp('Running LowPass Filter as Average, Please Wait');
            f = fspecial('average', value);
            app.tempImage = imfilter(app.tempImage, f);
            disp('Finished!');
            updateCanva(app, app.tempImage);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create LPFUIFigure and hide until all components are created
            app.LPFUIFigure = uifigure('Visible', 'off');
            app.LPFUIFigure.Color = [0.1608 0.1608 0.1686];
            app.LPFUIFigure.Position = [100 60 300 400];
            app.LPFUIFigure.Name = 'MATLAB App';

            % Create UIAxes
            app.UIAxes = uiaxes(app.LPFUIFigure);
            title(app.UIAxes, '')
            xlabel(app.UIAxes, '')
            ylabel(app.UIAxes, '')
            app.UIAxes.Color = [0.1608 0.1608 0.1686];
            app.UIAxes.BackgroundColor = [0.1608 0.1608 0.1686];
            app.UIAxes.Position = [21 171 260 210];

            % Create CancelButton
            app.CancelButton = uibutton(app.LPFUIFigure, 'push');
            app.CancelButton.ButtonPushedFcn = createCallbackFcn(app, @CancelButtonPushed, true);
            app.CancelButton.Position = [22 22 120 32];
            app.CancelButton.Text = 'Cancel';

            % Create ApplyButton
            app.ApplyButton = uibutton(app.LPFUIFigure, 'push');
            app.ApplyButton.ButtonPushedFcn = createCallbackFcn(app, @ApplyButtonPushed, true);
            app.ApplyButton.Position = [160 22 120 32];
            app.ApplyButton.Text = 'Apply';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.LPFUIFigure);
            app.TabGroup.SelectionChangedFcn = createCallbackFcn(app, @TabGroupSelectionChanged, true);
            app.TabGroup.Position = [21 65 260 96];

            % Create MedianTab
            app.MedianTab = uitab(app.TabGroup);
            app.MedianTab.Title = 'Median';
            app.MedianTab.BackgroundColor = [0.1608 0.1608 0.1686];

            % Create AverageTab
            app.AverageTab = uitab(app.TabGroup);
            app.AverageTab.Title = 'Average';
            app.AverageTab.BackgroundColor = [0.1608 0.1608 0.1686];

            % Create ParameterEditFieldLabel
            app.ParameterEditFieldLabel = uilabel(app.AverageTab);
            app.ParameterEditFieldLabel.BackgroundColor = [0.1608 0.1608 0.1686];
            app.ParameterEditFieldLabel.HorizontalAlignment = 'right';
            app.ParameterEditFieldLabel.FontColor = [1 1 1];
            app.ParameterEditFieldLabel.Position = [38 25 62 22];
            app.ParameterEditFieldLabel.Text = 'Parameter';

            % Create ParameterEditField
            app.ParameterEditField = uieditfield(app.AverageTab, 'numeric');
            app.ParameterEditField.Limits = [0 Inf];
            app.ParameterEditField.ValueDisplayFormat = '%.0f';
            app.ParameterEditField.ValueChangedFcn = createCallbackFcn(app, @ParameterEditFieldValueChanged, true);
            app.ParameterEditField.FontColor = [1 1 1];
            app.ParameterEditField.BackgroundColor = [0.1608 0.1608 0.1686];
            app.ParameterEditField.Position = [115 25 100 22];

            % Show the figure after all components are created
            app.LPFUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = lpf_ui_exported(varargin)

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.LPFUIFigure)

            % Execute the startup function
            runStartupFcn(app, @(app)startupFcn(app, varargin{:}))

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.LPFUIFigure)
        end
    end
end