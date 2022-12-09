classdef salt_pepper_ui_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        SaltPepperUIFigure  matlab.ui.Figure
        UIAxes              matlab.ui.control.UIAxes
        CancelButton        matlab.ui.control.Button
        ApplyButton         matlab.ui.control.Button
        DSliderLabel        matlab.ui.control.Label
        DSlider             matlab.ui.control.Slider
    end

    
    properties (Access = private)
        mainApp; % Main App Object
        image;
        tempImage;
        
        d;
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
            
            app.d = 0.05;
            
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
                disp('Already binarized');
                app.tempImage = app.image;
            end
            
            try
                updateCanva(app, app.tempImage);
            catch M
                errordlg(M.message(), "Error");
                app.delete();
            end
        end

        % Callback function
        function DEditFieldValueChanged(app, event)
            app.d = app.DEditField.Value;
            
            app.tempImage = imnoise(app.image, 'salt & pepper', app.d);
            
            updateCanve(app, app.tempImage);            
        end

        % Button pushed function: ApplyButton
        function ApplyButtonPushed(app, event)
            app.mainApp.tempImage = app.tempImage;
            app.mainApp.updateCanvaImage(app.mainApp.tempImage);
            app.delete();
        end

        % Button pushed function: CancelButton
        function CancelButtonPushed(app, event)
            app.delete();
        end

        % Value changed function: DSlider
        function DSliderValueChanged(app, event)
            app.d = app.DSlider.Value;
            
            disp('Running Salt & Pepper, Please Wait...');
            app.tempImage = imnoise(app.image, 'salt & pepper', app.d);
            disp('Done.')
            
            updateCanva(app, app.tempImage);  
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create SaltPepperUIFigure and hide until all components are created
            app.SaltPepperUIFigure = uifigure('Visible', 'off');
            app.SaltPepperUIFigure.Color = [0.1608 0.1608 0.1686];
            app.SaltPepperUIFigure.Position = [100 60 300 400];
            app.SaltPepperUIFigure.Name = 'Salt & Pepper';

            % Create UIAxes
            app.UIAxes = uiaxes(app.SaltPepperUIFigure);
            title(app.UIAxes, '')
            xlabel(app.UIAxes, '')
            ylabel(app.UIAxes, '')
            app.UIAxes.Color = [0.1608 0.1608 0.1686];
            app.UIAxes.BackgroundColor = [0.1608 0.1608 0.1686];
            app.UIAxes.Position = [21 131 260 250];

            % Create CancelButton
            app.CancelButton = uibutton(app.SaltPepperUIFigure, 'push');
            app.CancelButton.ButtonPushedFcn = createCallbackFcn(app, @CancelButtonPushed, true);
            app.CancelButton.Position = [21 19 120 32];
            app.CancelButton.Text = 'Cancel';

            % Create ApplyButton
            app.ApplyButton = uibutton(app.SaltPepperUIFigure, 'push');
            app.ApplyButton.ButtonPushedFcn = createCallbackFcn(app, @ApplyButtonPushed, true);
            app.ApplyButton.Position = [161 19 120 32];
            app.ApplyButton.Text = 'Apply';

            % Create DSliderLabel
            app.DSliderLabel = uilabel(app.SaltPepperUIFigure);
            app.DSliderLabel.HorizontalAlignment = 'right';
            app.DSliderLabel.FontColor = [1 1 1];
            app.DSliderLabel.Position = [31 89 25 22];
            app.DSliderLabel.Text = 'D';

            % Create DSlider
            app.DSlider = uislider(app.SaltPepperUIFigure);
            app.DSlider.Limits = [0 1];
            app.DSlider.ValueChangedFcn = createCallbackFcn(app, @DSliderValueChanged, true);
            app.DSlider.FontColor = [1 1 1];
            app.DSlider.Position = [77 98 173 3];

            % Show the figure after all components are created
            app.SaltPepperUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = salt_pepper_ui_exported(varargin)

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.SaltPepperUIFigure)

            % Execute the startup function
            runStartupFcn(app, @(app)startupFcn(app, varargin{:}))

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.SaltPepperUIFigure)
        end
    end
end