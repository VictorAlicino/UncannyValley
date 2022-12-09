classdef zerox_ui_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        ZeroXUIFigure        matlab.ui.Figure
        UIAxes               matlab.ui.control.UIAxes
        CancelButton         matlab.ui.control.Button
        ApplyButton          matlab.ui.control.Button
        AlphaSliderLabel     matlab.ui.control.Label
        AlphaSlider          matlab.ui.control.Slider
        NumericMatrixLabel   matlab.ui.control.Label
        NumericMatrixSlider  matlab.ui.control.Slider
    end

    
    properties (Access = private)
        mainApp; % Main App Object
        image;
        tempImage;
        
        alpha;
        numericMatrix;
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
            
            app.alpha = 0;
            app.numericMatrix = 1;
            
            % Test if image is RGB or Binary
            [~, ~, numberOfColorChannels] = size(app.mainApp.tempImage);
            if numberOfColorChannels > 1
                % It's not really gray scale like we expected - it's color.
                app.tempImage = rgb2gray(app.image);
            end
            
            app.image = app.tempImage;
            updateCanva(app, app.tempImage);
        end

        % Button pushed function: CancelButton
        function CancelButtonPushed(app, event)
            app.delete();
        end

        % Callback function
        function AlphaEditFieldValueChanged(app, event)
            app.alpha = app.AlphaEditField.Value;
            
            f = fspecial('unsharp', app.alpha);
            app.tempImage = edge(app.tempImage, 'zerocross', app.numericMatrix, f);
            
            updateCanva(app, app.tempImage);
        end

        % Callback function
        function NumericMatrixEditFieldValueChanged(app, event)
            app.numericMatrix = app.NumericMatrixEditField.Value;
            
            f = fspecial('unsharp', app.alpha);
            app.tempImage = edge(app.image, 'zerocross', app.numericMatrix, f);
            
            updateCanva(app, app.tempImage);
        end

        % Button pushed function: ApplyButton
        function ApplyButtonPushed(app, event)
            app.mainApp.tempImage = app.tempImage;
            app.mainApp.updateCanvaImage(app.mainApp.tempImage);
            app.delete();
        end

        % Value changed function: AlphaSlider
        function AlphaSliderValueChanged(app, event)
            app.alpha = app.AlphaSlider.Value;
            
            f = fspecial('unsharp', app.alpha);
            app.tempImage = edge(app.image, 'zerocross', app.numericMatrix, f);
            
            updateCanva(app, app.tempImage);
        end

        % Value changed function: NumericMatrixSlider
        function NumericMatrixSliderValueChanged(app, event)
            app.numericMatrix = app.NumericMatrixSlider.Value;
            
            f = fspecial('unsharp', app.alpha);
            app.tempImage = edge(app.image, 'zerocross', app.numericMatrix, f);
            
            updateCanva(app, app.tempImage);
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create ZeroXUIFigure and hide until all components are created
            app.ZeroXUIFigure = uifigure('Visible', 'off');
            app.ZeroXUIFigure.Color = [0.1608 0.1608 0.1686];
            app.ZeroXUIFigure.Position = [100 60 300 410];
            app.ZeroXUIFigure.Name = 'ZeroCross';

            % Create UIAxes
            app.UIAxes = uiaxes(app.ZeroXUIFigure);
            title(app.UIAxes, '')
            xlabel(app.UIAxes, '')
            ylabel(app.UIAxes, '')
            app.UIAxes.Color = [0.1608 0.1608 0.1686];
            app.UIAxes.BackgroundColor = [0.1608 0.1608 0.1686];
            app.UIAxes.Position = [21 181 260 210];

            % Create CancelButton
            app.CancelButton = uibutton(app.ZeroXUIFigure, 'push');
            app.CancelButton.ButtonPushedFcn = createCallbackFcn(app, @CancelButtonPushed, true);
            app.CancelButton.Position = [21 14 120 32];
            app.CancelButton.Text = 'Cancel';

            % Create ApplyButton
            app.ApplyButton = uibutton(app.ZeroXUIFigure, 'push');
            app.ApplyButton.ButtonPushedFcn = createCallbackFcn(app, @ApplyButtonPushed, true);
            app.ApplyButton.Position = [161 14 120 32];
            app.ApplyButton.Text = 'Apply';

            % Create AlphaSliderLabel
            app.AlphaSliderLabel = uilabel(app.ZeroXUIFigure);
            app.AlphaSliderLabel.HorizontalAlignment = 'right';
            app.AlphaSliderLabel.FontColor = [1 1 1];
            app.AlphaSliderLabel.Position = [42 144 36 22];
            app.AlphaSliderLabel.Text = 'Alpha';

            % Create AlphaSlider
            app.AlphaSlider = uislider(app.ZeroXUIFigure);
            app.AlphaSlider.Limits = [0 1];
            app.AlphaSlider.ValueChangedFcn = createCallbackFcn(app, @AlphaSliderValueChanged, true);
            app.AlphaSlider.FontColor = [1 1 1];
            app.AlphaSlider.Position = [99 153 150 3];

            % Create NumericMatrixLabel
            app.NumericMatrixLabel = uilabel(app.ZeroXUIFigure);
            app.NumericMatrixLabel.HorizontalAlignment = 'right';
            app.NumericMatrixLabel.FontColor = [1 1 1];
            app.NumericMatrixLabel.Position = [28 80 50 28];
            app.NumericMatrixLabel.Text = {'Numeric'; 'Matrix'};

            % Create NumericMatrixSlider
            app.NumericMatrixSlider = uislider(app.ZeroXUIFigure);
            app.NumericMatrixSlider.Limits = [0 1];
            app.NumericMatrixSlider.ValueChangedFcn = createCallbackFcn(app, @NumericMatrixSliderValueChanged, true);
            app.NumericMatrixSlider.FontColor = [1 1 1];
            app.NumericMatrixSlider.Position = [99 95 150 3];

            % Show the figure after all components are created
            app.ZeroXUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = zerox_ui_exported(varargin)

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.ZeroXUIFigure)

            % Execute the startup function
            runStartupFcn(app, @(app)startupFcn(app, varargin{:}))

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.ZeroXUIFigure)
        end
    end
end