classdef count_objects_ui_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        CountObjectsUIFigure  matlab.ui.Figure
        UIAxes                matlab.ui.control.UIAxes
        OkButton              matlab.ui.control.Button
        TSliderLabel          matlab.ui.control.Label
        TSlider               matlab.ui.control.Slider
        ObjectsdetectedLabel  matlab.ui.control.Label
        Label                 matlab.ui.control.Label
        PEditFieldLabel       matlab.ui.control.Label
        PEditField            matlab.ui.control.NumericEditField
    end

    
    properties (Access = private)
        mainApp; % Main App Object
        image;
        tempImage;
        
        p1;
        bw;
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
            
            app.p1 = 0;
            app.bw = 0;
            
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
            end
            
            app.tempImage = imbinarize(app.image, app.bw);
            
            updateCanva(app, app.tempImage);
        end

        % Value changed function: TSlider
        function TSliderValueChanged(app, event)
            app.bw = app.TSlider.Value;
            
            app.tempImage = imbinarize(app.image, app.bw);
            updateCanva(app, app.tempImage);
            [~, I] = bwboundaries(app.tempImage, 'noholes');
            s = regionprops(I, 'Area');
            objs = sum([s.Area]>app.p1);
            app.Label.Text = sprintf('%.6f',objs);
        end

        % Value changed function: PEditField
        function PEditFieldValueChanged(app, event)
            app.p1 = app.PEditField.Value;
            
            [~, I] = bwboundaries(app.tempImage, 'noholes');
            s = regionprops(I, 'Area');
            objs = sum([s.Area]>app.p1);
            
            app.Label.Text = sprintf('%.6f',objs);
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

            % Create CountObjectsUIFigure and hide until all components are created
            app.CountObjectsUIFigure = uifigure('Visible', 'off');
            app.CountObjectsUIFigure.Color = [0.1608 0.1608 0.1686];
            app.CountObjectsUIFigure.Position = [100 60 400 450];
            app.CountObjectsUIFigure.Name = 'Count Objects';

            % Create UIAxes
            app.UIAxes = uiaxes(app.CountObjectsUIFigure);
            title(app.UIAxes, '')
            xlabel(app.UIAxes, '')
            ylabel(app.UIAxes, '')
            app.UIAxes.Color = [0.1608 0.1608 0.1686];
            app.UIAxes.BackgroundColor = [0.1608 0.1608 0.1686];
            app.UIAxes.Position = [109 211 262 210];

            % Create OkButton
            app.OkButton = uibutton(app.CountObjectsUIFigure, 'push');
            app.OkButton.ButtonPushedFcn = createCallbackFcn(app, @OkButtonPushed, true);
            app.OkButton.Position = [141 29 120 32];
            app.OkButton.Text = 'Ok';

            % Create TSliderLabel
            app.TSliderLabel = uilabel(app.CountObjectsUIFigure);
            app.TSliderLabel.HorizontalAlignment = 'right';
            app.TSliderLabel.FontColor = [1 1 1];
            app.TSliderLabel.Position = [6 204 25 22];
            app.TSliderLabel.Text = 'T';

            % Create TSlider
            app.TSlider = uislider(app.CountObjectsUIFigure);
            app.TSlider.Limits = [0 1];
            app.TSlider.Orientation = 'vertical';
            app.TSlider.ValueChangedFcn = createCallbackFcn(app, @TSliderValueChanged, true);
            app.TSlider.FontColor = [1 1 1];
            app.TSlider.Position = [52 213 3 201];

            % Create ObjectsdetectedLabel
            app.ObjectsdetectedLabel = uilabel(app.CountObjectsUIFigure);
            app.ObjectsdetectedLabel.FontColor = [1 1 1];
            app.ObjectsdetectedLabel.Position = [115 101 99 22];
            app.ObjectsdetectedLabel.Text = 'Objects detected:';

            % Create Label
            app.Label = uilabel(app.CountObjectsUIFigure);
            app.Label.HorizontalAlignment = 'right';
            app.Label.FontColor = [1 1 1];
            app.Label.Position = [274 101 26 22];
            app.Label.Text = '000';

            % Create PEditFieldLabel
            app.PEditFieldLabel = uilabel(app.CountObjectsUIFigure);
            app.PEditFieldLabel.BackgroundColor = [0.149 0.149 0.149];
            app.PEditFieldLabel.HorizontalAlignment = 'right';
            app.PEditFieldLabel.FontColor = [1 1 1];
            app.PEditFieldLabel.Position = [97 143 25 22];
            app.PEditFieldLabel.Text = 'P';

            % Create PEditField
            app.PEditField = uieditfield(app.CountObjectsUIFigure, 'numeric');
            app.PEditField.Limits = [0 Inf];
            app.PEditField.ValueChangedFcn = createCallbackFcn(app, @PEditFieldValueChanged, true);
            app.PEditField.FontColor = [1 1 1];
            app.PEditField.BackgroundColor = [0.149 0.149 0.149];
            app.PEditField.Position = [169 143 134 22];

            % Show the figure after all components are created
            app.CountObjectsUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = count_objects_ui_exported(varargin)

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.CountObjectsUIFigure)

            % Execute the startup function
            runStartupFcn(app, @(app)startupFcn(app, varargin{:}))

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.CountObjectsUIFigure)
        end
    end
end