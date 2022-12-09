classdef ui_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UncannyValleyUIFigure  matlab.ui.Figure
        FileMenu               matlab.ui.container.Menu
        LoadMenu               matlab.ui.container.Menu
        ExitMenu               matlab.ui.container.Menu
        ImageMenu              matlab.ui.container.Menu
        FittoscreenMenu        matlab.ui.container.Menu
        ShowOriginalMenu_2     matlab.ui.container.Menu
        ShowCurrentMenu        matlab.ui.container.Menu
        ResetAllMenu           matlab.ui.container.Menu
        ToolsMenu              matlab.ui.container.Menu
        CountObjectsMenu       matlab.ui.container.Menu
        TabGroup               matlab.ui.container.TabGroup
        FiltersTab             matlab.ui.container.Tab
        ThresholdButton        matlab.ui.control.Button
        GrayscaleButton        matlab.ui.control.Button
        RobertsButton          matlab.ui.control.Button
        PrewittButton          matlab.ui.control.Button
        SobelButton            matlab.ui.control.Button
        LogButton              matlab.ui.control.Button
        ZeroXButton            matlab.ui.control.Button
        CannyButton            matlab.ui.control.Button
        HighPassButton         matlab.ui.control.Button
        LowPassButton          matlab.ui.control.Button
        NoiseTab               matlab.ui.container.Tab
        SaltPepperButton       matlab.ui.control.Button
        GaussianButton         matlab.ui.control.Button
        TechnicquesTab         matlab.ui.container.Tab
        WatershedButton        matlab.ui.control.Button
        ImageCanva             matlab.ui.control.UIAxes
        ImageContextMenu       matlab.ui.container.ContextMenu
        ShowOriginalMenu       matlab.ui.container.Menu
        ShowCurrentImageMenu   matlab.ui.container.Menu
    end

    
    properties (Access = public)
        originalImage;   % Original image matrix
        tempImage;       % Temp image matrix, which will be altered
        
        threshold_app;   % Threshold UI window
        canva_x_lim;
        canva_y_lim;
    end
    
    methods (Access = public)
        
        function updateCanvaImage(app, image)
            if numel(image) > 0
                [~, ~, numberOfColorChannels] = size(image);
                disp(numberOfColorChannels);
                if numberOfColorChannels > 1
                    updateCanvaTriDimen(app, image);
                else
                    updateCanvaBiDimen(app, image);                
                end
            end
        end
        
        function updateCanvaBiDimen(app, image)
            disp('Rendering bw image....');
            %app.ImageCanva.Position = [0 0 app.UncannyValleyUIFigure.Position(3:4)];
            
            I = imshow(image, 'parent', app.ImageCanva);
            disp(I)
            
            app.ImageCanva.XAxis.TickLabels = {};
            app.ImageCanva.YAxis.TickLabels = {};
            
            app.ImageCanva.XLim = app.canva_x_lim;
            app.ImageCanva.YLim = app.canva_y_lim;
            
            disp('Rendering complete.');
        end
        
        function updateCanvaTriDimen(app, image)
            disp('Rendering rgb image....');
            %app.ImageCanva.Position = [0 0 app.UncannyValleyUIFigure.Position(3:4)];
            
            I = imshow(image, 'parent', app.ImageCanva);
            
            app.ImageCanva.XAxis.TickLabels = {};
            app.ImageCanva.YAxis.TickLabels = {};
            
            app.ImageCanva.XLim = app.canva_x_lim;
            app.ImageCanva.YLim = app.canva_y_lim;
            disp('Rendering complete.');
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Menu selected function: LoadMenu
        function onLoadMenu(app, event)
            [originalFileName, originalFileDirPath] = uigetfile({ ...
                    '*.gif;*.jpeg;*.jpg;*.png;*.svg' ...
                    }, 'Load Image' ...
                );
            originalFilePath = fullfile(originalFileDirPath, originalFileName);
            try
                app.originalImage = imread(originalFilePath);
                app.tempImage = app.originalImage;
            
                disp('Rendering original image....');
                %app.ImageCanva.Position = [0 0 app.UncannyValleyUIFigure.Position(3:4)];
            
                I = imshow(app.tempImage, 'parent', app.ImageCanva);
            
                app.ImageCanva.XAxis.TickLabels = {};
                app.ImageCanva.YAxis.TickLabels = {};
            
                app.canva_x_lim = [0 I.XData(2)];
                app.canva_y_lim = [0 I.YData(2)];
                app.ImageCanva.XLim = app.canva_x_lim;
                app.ImageCanva.YLim = app.canva_y_lim;
                disp('Rendering complete.');
            catch M
                disp(M);
                errordlg('Invalid file', 'Error loading image');
            end
        end

        % Menu selected function: ExitMenu
        function onExitMenu(app, event)
            delete(app) % Don't know if this is really the way to close the app, but it works
        end

        % Button pushed function: ThresholdButton
        function ThresholdButtonPushed(app, event)
            app.ThresholdButton.Enable = 'off';
            threshold_ui(app);
            app.ThresholdButton.Enable = 'on';
        end

        % Menu selected function: ShowOriginalMenu, 
        % ShowOriginalMenu_2
        function ShowOriginalMenuSelected(app, event)
            updateCanvaImage(app, app.originalImage);
        end

        % Menu selected function: ShowCurrentImageMenu, 
        % ShowCurrentMenu
        function ShowCurrentImageMenuSelected(app, event)
            updateCanvaImage(app, app.tempImage);
        end

        % Menu selected function: ResetAllMenu
        function ResetAllMenuSelected(app, event)
            app.tempImage = app.originalImage;
            updateCanvaImage(app, app.tempImage);
        end

        % Menu selected function: FittoscreenMenu
        function FittoscreenMenuSelected(app, event)
            updateCanvaImage(app, app.tempImage);
        end

        % Button pushed function: GrayscaleButton
        function GrayscaleButtonPushed(app, event)
            app.GrayscaleButton.Enable = 'off';
            grayscale_ui(app);
            app.GrayscaleButton.Enable = 'on';
        end

        % Button pushed function: HighPassButton
        function HighPassButtonPushed(app, event)
            app.HighPassButton.Enable = 'off';
            hpf_ui(app);
            app.HighPassButton.Enable = 'on';
        end

        % Button pushed function: LowPassButton
        function LowPassButtonPushed(app, event)
            app.LowPassButton.Enable = 'off';
            lpf_ui(app);
            app.LowPassButton.Enable = 'on';
        end

        % Button pushed function: RobertsButton
        function RobertsButtonPushed(app, event)
            app.RobertsButton.Enable = 'off';
            roberts_ui(app);
            app.RobertsButton.Enable = 'on';
        end

        % Button pushed function: PrewittButton
        function PrewittButtonPushed(app, event)
            app.PrewittButton.Enable = 'off';
            prewitt_ui(app);
            app.PrewittButton.Enable = 'on';
        end

        % Button pushed function: SobelButton
        function SobelButtonPushed(app, event)
            app.SobelButton.Enable = 'off';
            sobel_ui(app);
            app.SobelButton.Enable = 'on';
        end

        % Button pushed function: LogButton
        function LogButtonPushed(app, event)
            app.LogButton.Enable = 'off';
            log_ui(app);
            app.LogButton.Enable = 'on';
        end

        % Button pushed function: ZeroXButton
        function ZeroXButtonPushed(app, event)
            app.ZeroXButton.Enable = 'off';
            zerox_ui(app);
            app.ZeroXButton.Enable = 'on';
        end

        % Button pushed function: CannyButton
        function CannyButtonPushed(app, event)
            app.CannyButton.Enable = 'off';
            canny_ui(app);
            app.CannyButton.Enable = 'on';
        end

        % Button pushed function: SaltPepperButton
        function SaltPepperButtonPushed(app, event)
            app.CannyButton.Enable = 'off';
            salt_pepper_ui(app);
            app.CannyButton.Enable = 'on';
        end

        % Button pushed function: GaussianButton
        function GaussianButtonPushed(app, event)
            app.GaussianButton.Enable = 'off';
            gaussian_ui(app);
            app.GaussianButton.Enable = 'on';
        end

        % Button pushed function: WatershedButton
        function WatershedButtonPushed(app, event)
            app.WatershedButton.Enable = 'off';
            watershed_ui(app);
            app.WatershedButton.Enable = 'on';
        end

        % Menu selected function: CountObjectsMenu
        function CountObjectsMenuSelected(app, event)
            count_objects_ui(app);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UncannyValleyUIFigure and hide until all components are created
            app.UncannyValleyUIFigure = uifigure('Visible', 'off');
            app.UncannyValleyUIFigure.AutoResizeChildren = 'off';
            app.UncannyValleyUIFigure.Color = [0.1608 0.1608 0.1686];
            app.UncannyValleyUIFigure.Colormap = [0.2431 0.149 0.6588;0.2431 0.1529 0.6745;0.2471 0.1569 0.6863;0.2471 0.1608 0.698;0.251 0.1647 0.7059;0.251 0.1686 0.7176;0.2549 0.1725 0.7294;0.2549 0.1765 0.7412;0.2588 0.1804 0.749;0.2588 0.1843 0.7608;0.2627 0.1882 0.7725;0.2588 0.1882 0.7804;0.2627 0.1961 0.7922;0.2667 0.2 0.8039;0.2667 0.2039 0.8157;0.2706 0.2078 0.8235;0.2706 0.2157 0.8353;0.2706 0.2196 0.8431;0.2745 0.2235 0.851;0.2745 0.2275 0.8627;0.2745 0.2314 0.8706;0.2745 0.2392 0.8784;0.2784 0.2431 0.8824;0.2784 0.2471 0.8902;0.2784 0.2549 0.898;0.2784 0.2588 0.902;0.2784 0.2667 0.9098;0.2784 0.2706 0.9137;0.2784 0.2745 0.9216;0.2824 0.2824 0.9255;0.2824 0.2863 0.9294;0.2824 0.2941 0.9333;0.2824 0.298 0.9412;0.2824 0.3059 0.9451;0.2824 0.3098 0.949;0.2824 0.3137 0.9529;0.2824 0.3216 0.9569;0.2824 0.3255 0.9608;0.2824 0.3294 0.9647;0.2784 0.3373 0.9686;0.2784 0.3412 0.9686;0.2784 0.349 0.9725;0.2784 0.3529 0.9765;0.2784 0.3569 0.9804;0.2784 0.3647 0.9804;0.2745 0.3686 0.9843;0.2745 0.3765 0.9843;0.2745 0.3804 0.9882;0.2706 0.3843 0.9882;0.2706 0.3922 0.9922;0.2667 0.3961 0.9922;0.2627 0.4039 0.9922;0.2627 0.4078 0.9961;0.2588 0.4157 0.9961;0.2549 0.4196 0.9961;0.251 0.4275 0.9961;0.2471 0.4314 1;0.2431 0.4392 1;0.2353 0.4431 1;0.2314 0.451 1;0.2235 0.4549 1;0.2196 0.4627 0.9961;0.2118 0.4667 0.9961;0.2078 0.4745 0.9922;0.2 0.4784 0.9922;0.1961 0.4863 0.9882;0.1922 0.4902 0.9882;0.1882 0.498 0.9843;0.1843 0.502 0.9804;0.1843 0.5098 0.9804;0.1804 0.5137 0.9765;0.1804 0.5176 0.9725;0.1804 0.5255 0.9725;0.1804 0.5294 0.9686;0.1765 0.5333 0.9647;0.1765 0.5412 0.9608;0.1765 0.5451 0.9569;0.1765 0.549 0.9529;0.1765 0.5569 0.949;0.1725 0.5608 0.9451;0.1725 0.5647 0.9412;0.1686 0.5686 0.9373;0.1647 0.5765 0.9333;0.1608 0.5804 0.9294;0.1569 0.5843 0.9255;0.1529 0.5922 0.9216;0.1529 0.5961 0.9176;0.149 0.6 0.9137;0.149 0.6039 0.9098;0.1451 0.6078 0.9098;0.1451 0.6118 0.9059;0.1412 0.6196 0.902;0.1412 0.6235 0.898;0.1373 0.6275 0.898;0.1373 0.6314 0.8941;0.1333 0.6353 0.8941;0.1294 0.6392 0.8902;0.1255 0.6471 0.8902;0.1216 0.651 0.8863;0.1176 0.6549 0.8824;0.1137 0.6588 0.8824;0.1137 0.6627 0.8784;0.1098 0.6667 0.8745;0.1059 0.6706 0.8706;0.102 0.6745 0.8667;0.098 0.6784 0.8627;0.0902 0.6824 0.8549;0.0863 0.6863 0.851;0.0784 0.6902 0.8471;0.0706 0.6941 0.8392;0.0627 0.698 0.8353;0.0549 0.702 0.8314;0.0431 0.702 0.8235;0.0314 0.7059 0.8196;0.0235 0.7098 0.8118;0.0157 0.7137 0.8078;0.0078 0.7176 0.8;0.0039 0.7176 0.7922;0 0.7216 0.7882;0 0.7255 0.7804;0 0.7294 0.7765;0.0039 0.7294 0.7686;0.0078 0.7333 0.7608;0.0157 0.7333 0.7569;0.0235 0.7373 0.749;0.0353 0.7412 0.7412;0.051 0.7412 0.7373;0.0627 0.7451 0.7294;0.0784 0.7451 0.7216;0.0902 0.749 0.7137;0.102 0.7529 0.7098;0.1137 0.7529 0.702;0.1255 0.7569 0.6941;0.1373 0.7569 0.6863;0.1451 0.7608 0.6824;0.1529 0.7608 0.6745;0.1608 0.7647 0.6667;0.1686 0.7647 0.6588;0.1725 0.7686 0.651;0.1804 0.7686 0.6471;0.1843 0.7725 0.6392;0.1922 0.7725 0.6314;0.1961 0.7765 0.6235;0.2 0.7804 0.6157;0.2078 0.7804 0.6078;0.2118 0.7843 0.6;0.2196 0.7843 0.5882;0.2235 0.7882 0.5804;0.2314 0.7882 0.5725;0.2392 0.7922 0.5647;0.251 0.7922 0.5529;0.2588 0.7922 0.5451;0.2706 0.7961 0.5373;0.2824 0.7961 0.5255;0.2941 0.7961 0.5176;0.3059 0.8 0.5059;0.3176 0.8 0.498;0.3294 0.8 0.4863;0.3412 0.8 0.4784;0.3529 0.8 0.4667;0.3686 0.8039 0.4549;0.3804 0.8039 0.4471;0.3922 0.8039 0.4353;0.4039 0.8039 0.4235;0.4196 0.8039 0.4118;0.4314 0.8039 0.4;0.4471 0.8039 0.3922;0.4627 0.8 0.3804;0.4745 0.8 0.3686;0.4902 0.8 0.3569;0.5059 0.8 0.349;0.5176 0.8 0.3373;0.5333 0.7961 0.3255;0.5451 0.7961 0.3176;0.5608 0.7961 0.3059;0.5765 0.7922 0.2941;0.5882 0.7922 0.2824;0.6039 0.7882 0.2745;0.6157 0.7882 0.2627;0.6314 0.7843 0.251;0.6431 0.7843 0.2431;0.6549 0.7804 0.2314;0.6706 0.7804 0.2235;0.6824 0.7765 0.2157;0.698 0.7765 0.2078;0.7098 0.7725 0.2;0.7216 0.7686 0.1922;0.7333 0.7686 0.1843;0.7451 0.7647 0.1765;0.7608 0.7647 0.1725;0.7725 0.7608 0.1647;0.7843 0.7569 0.1608;0.7961 0.7569 0.1569;0.8078 0.7529 0.1529;0.8157 0.749 0.1529;0.8275 0.749 0.1529;0.8392 0.7451 0.1529;0.851 0.7451 0.1569;0.8588 0.7412 0.1569;0.8706 0.7373 0.1608;0.8824 0.7373 0.1647;0.8902 0.7373 0.1686;0.902 0.7333 0.1765;0.9098 0.7333 0.1804;0.9176 0.7294 0.1882;0.9255 0.7294 0.1961;0.9373 0.7294 0.2078;0.9451 0.7294 0.2157;0.9529 0.7294 0.2235;0.9608 0.7294 0.2314;0.9686 0.7294 0.2392;0.9765 0.7294 0.2431;0.9843 0.7333 0.2431;0.9882 0.7373 0.2431;0.9961 0.7412 0.2392;0.9961 0.7451 0.2353;0.9961 0.7529 0.2314;0.9961 0.7569 0.2275;0.9961 0.7608 0.2235;0.9961 0.7686 0.2196;0.9961 0.7725 0.2157;0.9961 0.7804 0.2078;0.9961 0.7843 0.2039;0.9961 0.7922 0.2;0.9922 0.7961 0.1961;0.9922 0.8039 0.1922;0.9922 0.8078 0.1922;0.9882 0.8157 0.1882;0.9843 0.8235 0.1843;0.9843 0.8275 0.1804;0.9804 0.8353 0.1804;0.9765 0.8392 0.1765;0.9765 0.8471 0.1725;0.9725 0.851 0.1686;0.9686 0.8588 0.1647;0.9686 0.8667 0.1647;0.9647 0.8706 0.1608;0.9647 0.8784 0.1569;0.9608 0.8824 0.1569;0.9608 0.8902 0.1529;0.9608 0.898 0.149;0.9608 0.902 0.149;0.9608 0.9098 0.1451;0.9608 0.9137 0.1412;0.9608 0.9216 0.1373;0.9608 0.9255 0.1333;0.9608 0.9333 0.1294;0.9647 0.9373 0.1255;0.9647 0.9451 0.1216;0.9647 0.949 0.1176;0.9686 0.9569 0.1098;0.9686 0.9608 0.1059;0.9725 0.9686 0.102;0.9725 0.9725 0.0941;0.9765 0.9765 0.0863;0.9765 0.9843 0.0824];
            app.UncannyValleyUIFigure.Position = [100 65 1280 720];
            app.UncannyValleyUIFigure.Name = 'Uncanny Valley';
            app.UncannyValleyUIFigure.Resize = 'off';

            % Create FileMenu
            app.FileMenu = uimenu(app.UncannyValleyUIFigure);
            app.FileMenu.Text = 'File';

            % Create LoadMenu
            app.LoadMenu = uimenu(app.FileMenu);
            app.LoadMenu.MenuSelectedFcn = createCallbackFcn(app, @onLoadMenu, true);
            app.LoadMenu.Text = 'Load';

            % Create ExitMenu
            app.ExitMenu = uimenu(app.FileMenu);
            app.ExitMenu.MenuSelectedFcn = createCallbackFcn(app, @onExitMenu, true);
            app.ExitMenu.Text = 'Exit';

            % Create ImageMenu
            app.ImageMenu = uimenu(app.UncannyValleyUIFigure);
            app.ImageMenu.Text = 'Image';

            % Create FittoscreenMenu
            app.FittoscreenMenu = uimenu(app.ImageMenu);
            app.FittoscreenMenu.MenuSelectedFcn = createCallbackFcn(app, @FittoscreenMenuSelected, true);
            app.FittoscreenMenu.Text = 'Fit-to-screen';

            % Create ShowOriginalMenu_2
            app.ShowOriginalMenu_2 = uimenu(app.ImageMenu);
            app.ShowOriginalMenu_2.MenuSelectedFcn = createCallbackFcn(app, @ShowOriginalMenuSelected, true);
            app.ShowOriginalMenu_2.Text = 'Show Original';

            % Create ShowCurrentMenu
            app.ShowCurrentMenu = uimenu(app.ImageMenu);
            app.ShowCurrentMenu.MenuSelectedFcn = createCallbackFcn(app, @ShowCurrentImageMenuSelected, true);
            app.ShowCurrentMenu.Text = 'Show Current';

            % Create ResetAllMenu
            app.ResetAllMenu = uimenu(app.ImageMenu);
            app.ResetAllMenu.MenuSelectedFcn = createCallbackFcn(app, @ResetAllMenuSelected, true);
            app.ResetAllMenu.Text = 'Reset All';

            % Create ToolsMenu
            app.ToolsMenu = uimenu(app.UncannyValleyUIFigure);
            app.ToolsMenu.Text = 'Tools';

            % Create CountObjectsMenu
            app.CountObjectsMenu = uimenu(app.ToolsMenu);
            app.CountObjectsMenu.MenuSelectedFcn = createCallbackFcn(app, @CountObjectsMenuSelected, true);
            app.CountObjectsMenu.Text = 'Count Objects';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UncannyValleyUIFigure);
            app.TabGroup.AutoResizeChildren = 'off';
            app.TabGroup.Position = [1001 0 280 723];

            % Create FiltersTab
            app.FiltersTab = uitab(app.TabGroup);
            app.FiltersTab.AutoResizeChildren = 'off';
            app.FiltersTab.Title = 'Filters';
            app.FiltersTab.BackgroundColor = [0.1882 0.1882 0.2];

            % Create ThresholdButton
            app.ThresholdButton = uibutton(app.FiltersTab, 'push');
            app.ThresholdButton.ButtonPushedFcn = createCallbackFcn(app, @ThresholdButtonPushed, true);
            app.ThresholdButton.BackgroundColor = [0.8392 0.4 0.949];
            app.ThresholdButton.FontName = 'Monospaced';
            app.ThresholdButton.FontWeight = 'bold';
            app.ThresholdButton.FontColor = [1 1 1];
            app.ThresholdButton.Position = [21 645 240 33];
            app.ThresholdButton.Text = 'Threshold';

            % Create GrayscaleButton
            app.GrayscaleButton = uibutton(app.FiltersTab, 'push');
            app.GrayscaleButton.ButtonPushedFcn = createCallbackFcn(app, @GrayscaleButtonPushed, true);
            app.GrayscaleButton.BackgroundColor = [0.8392 0.4 0.949];
            app.GrayscaleButton.FontName = 'Monospaced';
            app.GrayscaleButton.FontWeight = 'bold';
            app.GrayscaleButton.FontColor = [1 1 1];
            app.GrayscaleButton.Position = [21 605 240 33];
            app.GrayscaleButton.Text = 'Grayscale';

            % Create RobertsButton
            app.RobertsButton = uibutton(app.FiltersTab, 'push');
            app.RobertsButton.ButtonPushedFcn = createCallbackFcn(app, @RobertsButtonPushed, true);
            app.RobertsButton.BackgroundColor = [0.8392 0.4 0.949];
            app.RobertsButton.FontName = 'Monospaced';
            app.RobertsButton.FontWeight = 'bold';
            app.RobertsButton.FontColor = [1 1 1];
            app.RobertsButton.Position = [21 485 240 33];
            app.RobertsButton.Text = 'Roberts';

            % Create PrewittButton
            app.PrewittButton = uibutton(app.FiltersTab, 'push');
            app.PrewittButton.ButtonPushedFcn = createCallbackFcn(app, @PrewittButtonPushed, true);
            app.PrewittButton.BackgroundColor = [0.8392 0.4 0.949];
            app.PrewittButton.FontName = 'Monospaced';
            app.PrewittButton.FontWeight = 'bold';
            app.PrewittButton.FontColor = [1 1 1];
            app.PrewittButton.Position = [21 445 240 33];
            app.PrewittButton.Text = 'Prewitt';

            % Create SobelButton
            app.SobelButton = uibutton(app.FiltersTab, 'push');
            app.SobelButton.ButtonPushedFcn = createCallbackFcn(app, @SobelButtonPushed, true);
            app.SobelButton.BackgroundColor = [0.8392 0.4 0.949];
            app.SobelButton.FontName = 'Monospaced';
            app.SobelButton.FontWeight = 'bold';
            app.SobelButton.FontColor = [1 1 1];
            app.SobelButton.Position = [21 405 240 33];
            app.SobelButton.Text = 'Sobel';

            % Create LogButton
            app.LogButton = uibutton(app.FiltersTab, 'push');
            app.LogButton.ButtonPushedFcn = createCallbackFcn(app, @LogButtonPushed, true);
            app.LogButton.BackgroundColor = [0.8392 0.4 0.949];
            app.LogButton.FontName = 'Monospaced';
            app.LogButton.FontWeight = 'bold';
            app.LogButton.FontColor = [1 1 1];
            app.LogButton.Position = [21 365 240 33];
            app.LogButton.Text = 'Log';

            % Create ZeroXButton
            app.ZeroXButton = uibutton(app.FiltersTab, 'push');
            app.ZeroXButton.ButtonPushedFcn = createCallbackFcn(app, @ZeroXButtonPushed, true);
            app.ZeroXButton.BackgroundColor = [0.8392 0.4 0.949];
            app.ZeroXButton.FontName = 'Monospaced';
            app.ZeroXButton.FontWeight = 'bold';
            app.ZeroXButton.FontColor = [1 1 1];
            app.ZeroXButton.Position = [21 325 240 33];
            app.ZeroXButton.Text = 'Zero-X';

            % Create CannyButton
            app.CannyButton = uibutton(app.FiltersTab, 'push');
            app.CannyButton.ButtonPushedFcn = createCallbackFcn(app, @CannyButtonPushed, true);
            app.CannyButton.BackgroundColor = [0.8392 0.4 0.949];
            app.CannyButton.FontName = 'Monospaced';
            app.CannyButton.FontWeight = 'bold';
            app.CannyButton.FontColor = [1 1 1];
            app.CannyButton.Position = [21 285 240 33];
            app.CannyButton.Text = 'Canny';

            % Create HighPassButton
            app.HighPassButton = uibutton(app.FiltersTab, 'push');
            app.HighPassButton.ButtonPushedFcn = createCallbackFcn(app, @HighPassButtonPushed, true);
            app.HighPassButton.BackgroundColor = [0.8392 0.4 0.949];
            app.HighPassButton.FontName = 'Monospaced';
            app.HighPassButton.FontWeight = 'bold';
            app.HighPassButton.FontColor = [1 1 1];
            app.HighPassButton.Position = [21 565 240 33];
            app.HighPassButton.Text = 'High Pass';

            % Create LowPassButton
            app.LowPassButton = uibutton(app.FiltersTab, 'push');
            app.LowPassButton.ButtonPushedFcn = createCallbackFcn(app, @LowPassButtonPushed, true);
            app.LowPassButton.BackgroundColor = [0.8392 0.4 0.949];
            app.LowPassButton.FontName = 'Monospaced';
            app.LowPassButton.FontWeight = 'bold';
            app.LowPassButton.FontColor = [1 1 1];
            app.LowPassButton.Position = [21 525 240 33];
            app.LowPassButton.Text = 'Low Pass';

            % Create NoiseTab
            app.NoiseTab = uitab(app.TabGroup);
            app.NoiseTab.AutoResizeChildren = 'off';
            app.NoiseTab.Title = 'Noise';
            app.NoiseTab.BackgroundColor = [0.1882 0.1882 0.2];

            % Create SaltPepperButton
            app.SaltPepperButton = uibutton(app.NoiseTab, 'push');
            app.SaltPepperButton.ButtonPushedFcn = createCallbackFcn(app, @SaltPepperButtonPushed, true);
            app.SaltPepperButton.BackgroundColor = [0.8392 0.4 0.949];
            app.SaltPepperButton.FontName = 'Monospaced';
            app.SaltPepperButton.FontWeight = 'bold';
            app.SaltPepperButton.FontColor = [1 1 1];
            app.SaltPepperButton.Position = [21 645 240 33];
            app.SaltPepperButton.Text = 'Salt & Pepper';

            % Create GaussianButton
            app.GaussianButton = uibutton(app.NoiseTab, 'push');
            app.GaussianButton.ButtonPushedFcn = createCallbackFcn(app, @GaussianButtonPushed, true);
            app.GaussianButton.BackgroundColor = [0.8392 0.4 0.949];
            app.GaussianButton.FontName = 'Monospaced';
            app.GaussianButton.FontWeight = 'bold';
            app.GaussianButton.FontColor = [1 1 1];
            app.GaussianButton.Position = [21 605 240 33];
            app.GaussianButton.Text = 'Gaussian';

            % Create TechnicquesTab
            app.TechnicquesTab = uitab(app.TabGroup);
            app.TechnicquesTab.AutoResizeChildren = 'off';
            app.TechnicquesTab.Title = 'Technicques';
            app.TechnicquesTab.BackgroundColor = [0.1882 0.1882 0.2];

            % Create WatershedButton
            app.WatershedButton = uibutton(app.TechnicquesTab, 'push');
            app.WatershedButton.ButtonPushedFcn = createCallbackFcn(app, @WatershedButtonPushed, true);
            app.WatershedButton.BackgroundColor = [0.8392 0.4 0.949];
            app.WatershedButton.FontName = 'Monospaced';
            app.WatershedButton.FontWeight = 'bold';
            app.WatershedButton.FontColor = [1 1 1];
            app.WatershedButton.Position = [21 645 240 33];
            app.WatershedButton.Text = 'Watershed';

            % Create ImageCanva
            app.ImageCanva = uiaxes(app.UncannyValleyUIFigure);
            title(app.ImageCanva, '')
            xlabel(app.ImageCanva, '')
            ylabel(app.ImageCanva, '')
            app.ImageCanva.AmbientLightColor = [0.1608 0.1608 0.1686];
            app.ImageCanva.XLim = [0 1];
            app.ImageCanva.YLim = [0 1];
            app.ImageCanva.Color = [0.1608 0.1608 0.1686];
            app.ImageCanva.BackgroundColor = [0.1608 0.1608 0.1686];
            app.ImageCanva.Position = [11 11 980 700];

            % Create ImageContextMenu
            app.ImageContextMenu = uicontextmenu(app.UncannyValleyUIFigure);
            
            % Assign app.ImageContextMenu
            app.ImageCanva.ContextMenu = app.ImageContextMenu;

            % Create ShowOriginalMenu
            app.ShowOriginalMenu = uimenu(app.ImageContextMenu);
            app.ShowOriginalMenu.MenuSelectedFcn = createCallbackFcn(app, @ShowOriginalMenuSelected, true);
            app.ShowOriginalMenu.Text = 'Show Original';

            % Create ShowCurrentImageMenu
            app.ShowCurrentImageMenu = uimenu(app.ImageContextMenu);
            app.ShowCurrentImageMenu.MenuSelectedFcn = createCallbackFcn(app, @ShowCurrentImageMenuSelected, true);
            app.ShowCurrentImageMenu.Text = 'Show Current Image';

            % Show the figure after all components are created
            app.UncannyValleyUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = ui_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UncannyValleyUIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UncannyValleyUIFigure)
        end
    end
end