classdef hpf_ui_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        HPFUIFigure    matlab.ui.Figure
        UIAxes         matlab.ui.control.UIAxes
        CancelButton   matlab.ui.control.Button
        ApplyButton    matlab.ui.control.Button
        TabGroup       matlab.ui.container.TabGroup
        BasicTab       matlab.ui.container.Tab
        Slider_2Label  matlab.ui.control.Label
        Slider_2       matlab.ui.control.Slider
        AltoReforoTab  matlab.ui.container.Tab
        SliderLabel    matlab.ui.control.Label
        Slider         matlab.ui.control.Slider
        SpinnerLabel   matlab.ui.control.Label
        Spinner        matlab.ui.control.Spinner
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
            
            app.slider1 = 0;
            app.number1 = 2;
            
            updateCanva(app, app.image);
        end

        % Button pushed function: CancelButton
        function CancelButtonPushed(app, event)
            app.delete();
        end

        % Button pushed function: ApplyButton
        function ApplyButtonPushed(app, event)
            app.mainApp.tempImage = app.tempImage;
            app.mainApp.updateCanvaImage(app.mainApp.tempImage);
            delete(app);
        end

        % Value changed function: Slider_2
        function Slider_2ValueChanged(app, event)
            value = app.Slider_2.Value;
            
            f = fspecial('unsharp', value);
            
            app.tempImage = imfilter(app.image, f);
            
            updateCanva(app, app.tempImage);
        end

        % Value changed function: Slider
        function SliderValueChanged(app, event)
            app.slider1 = app.Slider.Value;
            
            f = fspecial('unsharp', app.slider1);
            
            app.tempImage = imfilter(app.image, f);
            
            app.tempImage = (app.number1 - 1) * app.image + app.tempImage;
            
            updateCanva(app, app.tempImage);
        end

        % Value changed function: Spinner
        function SpinnerValueChanged(app, event)
            app.number1 = app.Spinner.Value;
            
            f = fspecial('unsharp', app.slider1);
            
            app.tempImage = imfilter(app.image, f);
            
            app.tempImage = (app.number1 - 1) * app.image + app.tempImage;
            
            updateCanva(app, app.tempImage);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create HPFUIFigure and hide until all components are created
            app.HPFUIFigure = uifigure('Visible', 'off');
            app.HPFUIFigure.Color = [0.1608 0.1608 0.1686];
            app.HPFUIFigure.Position = [100 60 300 450];
            app.HPFUIFigure.Name = 'High Pass';

            % Create UIAxes
            app.UIAxes = uiaxes(app.HPFUIFigure);
            title(app.UIAxes, '')
            xlabel(app.UIAxes, '')
            ylabel(app.UIAxes, '')
            app.UIAxes.Color = [0.1608 0.1608 0.1686];
            app.UIAxes.BackgroundColor = [0.1608 0.1608 0.1686];
            app.UIAxes.Position = [21 221 260 210];

            % Create CancelButton
            app.CancelButton = uibutton(app.HPFUIFigure, 'push');
            app.CancelButton.ButtonPushedFcn = createCallbackFcn(app, @CancelButtonPushed, true);
            app.CancelButton.Position = [31 9 120 32];
            app.CancelButton.Text = 'Cancel';

            % Create ApplyButton
            app.ApplyButton = uibutton(app.HPFUIFigure, 'push');
            app.ApplyButton.ButtonPushedFcn = createCallbackFcn(app, @ApplyButtonPushed, true);
            app.ApplyButton.Position = [161 9 120 32];
            app.ApplyButton.Text = 'Apply';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.HPFUIFigure);
            app.TabGroup.Position = [21 51 260 160];

            % Create BasicTab
            app.BasicTab = uitab(app.TabGroup);
            app.BasicTab.Title = 'Basic';
            app.BasicTab.BackgroundColor = [0.1608 0.1608 0.1686];

            % Create Slider_2Label
            app.Slider_2Label = uilabel(app.BasicTab);
            app.Slider_2Label.HorizontalAlignment = 'right';
            app.Slider_2Label.FontColor = [1 1 1];
            app.Slider_2Label.Position = [13 98 36 22];
            app.Slider_2Label.Text = 'Slider';

            % Create Slider_2
            app.Slider_2 = uislider(app.BasicTab);
            app.Slider_2.Limits = [0 1];
            app.Slider_2.ValueChangedFcn = createCallbackFcn(app, @Slider_2ValueChanged, true);
            app.Slider_2.FontColor = [1 1 1];
            app.Slider_2.Position = [70 107 170 3];

            % Create AltoReforoTab
            app.AltoReforoTab = uitab(app.TabGroup);
            app.AltoReforoTab.Title = 'Alto-Reforço';
            app.AltoReforoTab.BackgroundColor = [0.1608 0.1608 0.1686];

            % Create SliderLabel
            app.SliderLabel = uilabel(app.AltoReforoTab);
            app.SliderLabel.HorizontalAlignment = 'right';
            app.SliderLabel.FontColor = [1 1 1];
            app.SliderLabel.Position = [13 98 36 22];
            app.SliderLabel.Text = 'Slider';

            % Create Slider
            app.Slider = uislider(app.AltoReforoTab);
            app.Slider.Limits = [0 1];
            app.Slider.ValueChangedFcn = createCallbackFcn(app, @SliderValueChanged, true);
            app.Slider.FontColor = [1 1 1];
            app.Slider.Position = [70 107 170 3];

            % Create SpinnerLabel
            app.SpinnerLabel = uilabel(app.AltoReforoTab);
            app.SpinnerLabel.HorizontalAlignment = 'right';
            app.SpinnerLabel.FontColor = [1 1 1];
            app.SpinnerLabel.Position = [9 28 47 22];
            app.SpinnerLabel.Text = 'Spinner';

            % Create Spinner
            app.Spinner = uispinner(app.AltoReforoTab);
            app.Spinner.Limits = [0 100];
            app.Spinner.ValueDisplayFormat = '%.0f';
            app.Spinner.ValueChangedFcn = createCallbackFcn(app, @SpinnerValueChanged, true);
            app.Spinner.FontColor = [1 1 1];
            app.Spinner.BackgroundColor = [0.149 0.149 0.149];
            app.Spinner.Position = [71 28 169 22];
            app.Spinner.Value = 2;

            % Show the figure after all components are created
            app.HPFUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = hpf_ui_exported(varargin)

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.HPFUIFigure)

            % Execute the startup function
            runStartupFcn(app, @(app)startupFcn(app, varargin{:}))

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.HPFUIFigure)
        end
    end
end