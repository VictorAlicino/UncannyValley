classdef roberts_ui_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        RobertsUIFigure  matlab.ui.Figure
        UIAxes           matlab.ui.control.UIAxes
        CancelButton     matlab.ui.control.Button
        ApplyButton      matlab.ui.control.Button
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
            
            app.image = app.mainApp.tempImage;
            
            % Test if image is RGB or Binary
            [~, ~, numberOfColorChannels] = size(app.mainApp.tempImage);
            if numberOfColorChannels > 1
                % It's not really gray scale like we expected - it's color.
                f = rgb2gray(app.image);
                app.tempImage = edge(f, 'Roberts');
            else
                app.tempImage = edge(app.image, 'Roberts');
            end
            
            updateCanva(app, app.tempImage);
        end

        % Button pushed function: ApplyButton
        function ApplyButtonPushed(app, event)
            app.mainApp.tempImage = app.tempImage;
            app.mainApp.updateCanvaImage(app.mainApp.tempImage);
            app.delete()
        end

        % Button pushed function: CancelButton
        function CancelButtonPushed(app, event)
            app.delete()
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create RobertsUIFigure and hide until all components are created
            app.RobertsUIFigure = uifigure('Visible', 'off');
            app.RobertsUIFigure.Color = [0.1608 0.1608 0.1686];
            app.RobertsUIFigure.Position = [100 60 300 400];
            app.RobertsUIFigure.Name = 'Roberts';

            % Create UIAxes
            app.UIAxes = uiaxes(app.RobertsUIFigure);
            title(app.UIAxes, '')
            xlabel(app.UIAxes, '')
            ylabel(app.UIAxes, '')
            app.UIAxes.Color = [0.1608 0.1608 0.1686];
            app.UIAxes.BackgroundColor = [0.1608 0.1608 0.1686];
            app.UIAxes.Position = [21 71 260 310];

            % Create CancelButton
            app.CancelButton = uibutton(app.RobertsUIFigure, 'push');
            app.CancelButton.ButtonPushedFcn = createCallbackFcn(app, @CancelButtonPushed, true);
            app.CancelButton.Position = [22 22 120 32];
            app.CancelButton.Text = 'Cancel';

            % Create ApplyButton
            app.ApplyButton = uibutton(app.RobertsUIFigure, 'push');
            app.ApplyButton.ButtonPushedFcn = createCallbackFcn(app, @ApplyButtonPushed, true);
            app.ApplyButton.Position = [160 22 120 32];
            app.ApplyButton.Text = 'Apply';

            % Show the figure after all components are created
            app.RobertsUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = roberts_ui_exported(varargin)

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.RobertsUIFigure)

            % Execute the startup function
            runStartupFcn(app, @(app)startupFcn(app, varargin{:}))

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.RobertsUIFigure)
        end
    end
end