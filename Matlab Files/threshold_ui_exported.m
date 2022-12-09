classdef threshold_ui_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        ThresholdUIFigure  matlab.ui.Figure
        LevelSliderLabel   matlab.ui.control.Label
        LevelSlider        matlab.ui.control.Slider
        UIAxes             matlab.ui.control.UIAxes
        CancelButton       matlab.ui.control.Button
        ApplyButton        matlab.ui.control.Button
    end

    properties (Access = private)
        mainApp; % Main App Object
        image;
        tempImage;
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
            
            % Test if image is RGB or Binary
            [~, ~, numberOfColorChannels] = size(app.mainApp.tempImage);
            if numberOfColorChannels > 1
                % It's not really gray scale like we expected - it's color.
                app.image = rgb2gray(app.mainApp.tempImage);
            else
                app.image = app.mainApp.tempImage;                
            end
            updateCanva(app, app.image);
        end

        % Button pushed function: CancelButton
        function CancelButtonPushed(app, event)
            app.delete();
        end

        % Value changed function: LevelSlider
        function LevelSliderValueChanged(app, event)
            value = app.LevelSlider.Value;
            
            if not(islogical(app.image))
                app.tempImage = imbinarize(app.image, value);
                updateCanva(app, app.tempImage);
            else
                errordlg('Already binarized', 'Matrix is Logical')
                app.delete();
            end
        end

        % Button pushed function: ApplyButton
        function ApplyButtonPushed(app, event)
            app.mainApp.tempImage = app.tempImage;
            app.mainApp.updateCanvaImage(app.mainApp.tempImage);
            app.delete();
        end

        % Close request function: ThresholdUIFigure
        function ThresholdUIFigureCloseRequest(app, event)
            app.delete();
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create ThresholdUIFigure and hide until all components are created
            app.ThresholdUIFigure = uifigure('Visible', 'off');
            app.ThresholdUIFigure.Color = [0.1608 0.1608 0.1686];
            app.ThresholdUIFigure.Position = [100 60 300 400];
            app.ThresholdUIFigure.Name = 'Threshold';
            app.ThresholdUIFigure.CloseRequestFcn = createCallbackFcn(app, @ThresholdUIFigureCloseRequest, true);

            % Create LevelSliderLabel
            app.LevelSliderLabel = uilabel(app.ThresholdUIFigure);
            app.LevelSliderLabel.HorizontalAlignment = 'right';
            app.LevelSliderLabel.FontColor = [1 1 1];
            app.LevelSliderLabel.Position = [21 119 34 22];
            app.LevelSliderLabel.Text = 'Level';

            % Create LevelSlider
            app.LevelSlider = uislider(app.ThresholdUIFigure);
            app.LevelSlider.Limits = [0 1];
            app.LevelSlider.ValueChangedFcn = createCallbackFcn(app, @LevelSliderValueChanged, true);
            app.LevelSlider.FontColor = [1 1 1];
            app.LevelSlider.Position = [76 128 185 3];
            app.LevelSlider.Value = 1;

            % Create UIAxes
            app.UIAxes = uiaxes(app.ThresholdUIFigure);
            title(app.UIAxes, '')
            xlabel(app.UIAxes, '')
            ylabel(app.UIAxes, '')
            app.UIAxes.Color = [0.1608 0.1608 0.1686];
            app.UIAxes.BackgroundColor = [0.1608 0.1608 0.1686];
            app.UIAxes.Position = [21 171 260 210];

            % Create CancelButton
            app.CancelButton = uibutton(app.ThresholdUIFigure, 'push');
            app.CancelButton.ButtonPushedFcn = createCallbackFcn(app, @CancelButtonPushed, true);
            app.CancelButton.Position = [21 29 120 32];
            app.CancelButton.Text = 'Cancel';

            % Create ApplyButton
            app.ApplyButton = uibutton(app.ThresholdUIFigure, 'push');
            app.ApplyButton.ButtonPushedFcn = createCallbackFcn(app, @ApplyButtonPushed, true);
            app.ApplyButton.Position = [161 29 120 32];
            app.ApplyButton.Text = 'Apply';

            % Show the figure after all components are created
            app.ThresholdUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = threshold_ui_exported(varargin)

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.ThresholdUIFigure)

            % Execute the startup function
            runStartupFcn(app, @(app)startupFcn(app, varargin{:}))

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.ThresholdUIFigure)
        end
    end
end