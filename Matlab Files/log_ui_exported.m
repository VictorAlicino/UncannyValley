classdef log_ui_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        LogUIFigure   matlab.ui.Figure
        UIAxes        matlab.ui.control.UIAxes
        CancelButton  matlab.ui.control.Button
        ApplyButton   matlab.ui.control.Button
    end

    
    properties (Access = private)
        mainApp; % Main App Object
        image;
        tempImage;
        
        size;
        standardDeviation;
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
            
            % Test if image is RGB or Binary
            [~, ~, numberOfColorChannels] = size(app.mainApp.tempImage);
            if numberOfColorChannels > 1
                % It's not really gray scale like we expected - it's color.
                f = rgb2gray(app.image);
                app.tempImage = edge(f, 'log');
            else
                app.tempImage = edge(app.image, 'log');
            end
            
            updateCanva(app, app.tempImage);
        end

        % Callback function
        function SizeEditFieldValueChanged(app, event)
            app.size = app.SizeEditField.Value;

            f = fspecial('log', app.size, app.standardDeviation);
            app.tempImage = imfilter(app.tempImage, f);
            
            updateCanva(app, app.tempImage);
        end

        % Callback function
        function SDEditFieldValueChanged(app, event)
            app.standardDeviation = app.SDEditField.Value;

            f = fspecial('log', app.size, app.standardDeviation);
            app.tempImage = imfilter(app.tempImage, f);
            
            updateCanva(app, app.tempImage);
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
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create LogUIFigure and hide until all components are created
            app.LogUIFigure = uifigure('Visible', 'off');
            app.LogUIFigure.Color = [0.1608 0.1608 0.1686];
            app.LogUIFigure.Position = [100 60 300 400];
            app.LogUIFigure.Name = 'Log';

            % Create UIAxes
            app.UIAxes = uiaxes(app.LogUIFigure);
            title(app.UIAxes, '')
            xlabel(app.UIAxes, '')
            ylabel(app.UIAxes, '')
            app.UIAxes.Color = [0.1608 0.1608 0.1686];
            app.UIAxes.BackgroundColor = [0.1608 0.1608 0.1686];
            app.UIAxes.Position = [21 71 260 310];

            % Create CancelButton
            app.CancelButton = uibutton(app.LogUIFigure, 'push');
            app.CancelButton.ButtonPushedFcn = createCallbackFcn(app, @CancelButtonPushed, true);
            app.CancelButton.Position = [22 22 120 32];
            app.CancelButton.Text = 'Cancel';

            % Create ApplyButton
            app.ApplyButton = uibutton(app.LogUIFigure, 'push');
            app.ApplyButton.ButtonPushedFcn = createCallbackFcn(app, @ApplyButtonPushed, true);
            app.ApplyButton.Position = [160 22 120 32];
            app.ApplyButton.Text = 'Apply';

            % Show the figure after all components are created
            app.LogUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = log_ui_exported(varargin)

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.LogUIFigure)

            % Execute the startup function
            runStartupFcn(app, @(app)startupFcn(app, varargin{:}))

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.LogUIFigure)
        end
    end
end