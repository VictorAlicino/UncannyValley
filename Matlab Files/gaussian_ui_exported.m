classdef gaussian_ui_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        GaussianUIFigure  matlab.ui.Figure
        UIAxes            matlab.ui.control.UIAxes
        CancelButton      matlab.ui.control.Button
        ApplyButton       matlab.ui.control.Button
        MSliderLabel      matlab.ui.control.Label
        MSlider           matlab.ui.control.Slider
    end

    
    properties (Access = private)
        mainApp; % Main App Object
        image;
        tempImage;
        
        m;
    end
    
    methods (Access = private)
        
        function updateCanva(app, image)
            disp('Rendering...');
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
            disp('Rendered.');
            
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, mainApp)
            app.mainApp = mainApp;
            
            app.image = app.mainApp.tempImage;
            
            app.m = 0;
            
            if islogical(app.image)
                errordlg('Reset image to continue.', 'Matrix is logical');
                app.delete();
            end
            
            % Test if image is RGB or Binary
            [~, ~, numberOfColorChannels] = size(app.mainApp.tempImage);
            if numberOfColorChannels > 1
                % It's not really gray scale like we expected - it's color.
                app.image = rgb2gray(app.image);
                app.tempImage = app.image;
            else
                app.tempImage = app.image;
            end
            
            try
                updateCanva(app, app.tempImage);
            catch M
                errordlg(M.message(), 'Error');
                app.delete();
            end
        end

        % Button pushed function: CancelButton
        function CancelButtonPushed(app, event)
            app.delete();
        end

        % Button pushed function: ApplyButton
        function ApplyButtonPushed(app, event)
            app.mainApp.tempImage = app.tempImage;
            app.mainApp.updateCanvaImage(app.mainApp.tempImage);
            app.delete();
        end

        % Value changed function: MSlider
        function MSliderValueChanged(app, event)
            app.m = app.MSlider.Value;
            
            disp('Running Gaussian Noise, Please Wait...');
            app.tempImage = imnoise(app.image, 'gaussian', app.m);
            disp('Done.')
            
            updateCanva(app, app.tempImage);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create GaussianUIFigure and hide until all components are created
            app.GaussianUIFigure = uifigure('Visible', 'off');
            app.GaussianUIFigure.Color = [0.1608 0.1608 0.1686];
            app.GaussianUIFigure.Position = [100 60 300 400];
            app.GaussianUIFigure.Name = 'Gaussian';

            % Create UIAxes
            app.UIAxes = uiaxes(app.GaussianUIFigure);
            title(app.UIAxes, '')
            xlabel(app.UIAxes, '')
            ylabel(app.UIAxes, '')
            app.UIAxes.Color = [0.1608 0.1608 0.1686];
            app.UIAxes.BackgroundColor = [0.1608 0.1608 0.1686];
            app.UIAxes.Position = [21 131 260 250];

            % Create CancelButton
            app.CancelButton = uibutton(app.GaussianUIFigure, 'push');
            app.CancelButton.ButtonPushedFcn = createCallbackFcn(app, @CancelButtonPushed, true);
            app.CancelButton.Position = [21 19 120 32];
            app.CancelButton.Text = 'Cancel';

            % Create ApplyButton
            app.ApplyButton = uibutton(app.GaussianUIFigure, 'push');
            app.ApplyButton.ButtonPushedFcn = createCallbackFcn(app, @ApplyButtonPushed, true);
            app.ApplyButton.Position = [161 19 120 32];
            app.ApplyButton.Text = 'Apply';

            % Create MSliderLabel
            app.MSliderLabel = uilabel(app.GaussianUIFigure);
            app.MSliderLabel.HorizontalAlignment = 'right';
            app.MSliderLabel.FontColor = [1 1 1];
            app.MSliderLabel.Position = [31 89 25 22];
            app.MSliderLabel.Text = 'M';

            % Create MSlider
            app.MSlider = uislider(app.GaussianUIFigure);
            app.MSlider.Limits = [0 1];
            app.MSlider.ValueChangedFcn = createCallbackFcn(app, @MSliderValueChanged, true);
            app.MSlider.FontColor = [1 1 1];
            app.MSlider.Position = [77 98 173 3];

            % Show the figure after all components are created
            app.GaussianUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = gaussian_ui_exported(varargin)

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.GaussianUIFigure)

            % Execute the startup function
            runStartupFcn(app, @(app)startupFcn(app, varargin{:}))

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.GaussianUIFigure)
        end
    end
end