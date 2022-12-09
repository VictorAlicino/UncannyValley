classdef watershed_ui_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        WatershedUIFigure  matlab.ui.Figure
        UIAxes             matlab.ui.control.UIAxes
        OkButton           matlab.ui.control.Button
    end

    
    properties (Access = private)
        mainApp; % Main App Object
        image;
        tempImage;
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
            
            % Test if image is RGB or Binary
            [~, ~, numberOfColorChannels] = size(app.mainApp.tempImage);
            if numberOfColorChannels > 1
                % It's not really gray scale like we expected - it's color.
                app.image = rgb2gray(app.image);
                app.tempImage = app.image;
            end
            
            L = watershed(app.image);
            app.tempImage = label2rgb(L,'jet',[.5 .5 .5]);
            
            app.image = app.tempImage;
            updateCanva(app, app.tempImage);
        end

        % Button pushed function: OkButton
        function OkButtonPushed(app, event)
            app.delete();
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create WatershedUIFigure and hide until all components are created
            app.WatershedUIFigure = uifigure('Visible', 'off');
            app.WatershedUIFigure.Color = [0.1608 0.1608 0.1686];
            app.WatershedUIFigure.Position = [100 60 300 410];
            app.WatershedUIFigure.Name = 'Watershed';

            % Create UIAxes
            app.UIAxes = uiaxes(app.WatershedUIFigure);
            title(app.UIAxes, '')
            xlabel(app.UIAxes, '')
            ylabel(app.UIAxes, '')
            app.UIAxes.Color = [0.1608 0.1608 0.1686];
            app.UIAxes.BackgroundColor = [0.1608 0.1608 0.1686];
            app.UIAxes.Position = [21 71 260 320];

            % Create OkButton
            app.OkButton = uibutton(app.WatershedUIFigure, 'push');
            app.OkButton.ButtonPushedFcn = createCallbackFcn(app, @OkButtonPushed, true);
            app.OkButton.Position = [91 19 120 32];
            app.OkButton.Text = 'Ok';

            % Show the figure after all components are created
            app.WatershedUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = watershed_ui_exported(varargin)

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.WatershedUIFigure)

            % Execute the startup function
            runStartupFcn(app, @(app)startupFcn(app, varargin{:}))

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.WatershedUIFigure)
        end
    end
end