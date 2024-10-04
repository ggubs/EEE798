function plot3Dpattern(B1, theta1, phi1)
%PLOT3DPATTERN Summary of this function goes here

% Shift the beampattern to the origin
[theta_grid,phi_grid] = meshgrid(theta1, phi1);
B = reshape(B1,length(phi1),length(theta1));
B_shifted = B - min(B(:));

ax = axes();
hold on
add_x_y_z_labels(ax,max(B(:)));
add_az_el_labels(ax,max(B(:)));
draw_circle(ax, 90, 1:1:360,'--mw-graphics-colorSpace-rgb-blue','XY',1.1*max(B(:))); % Circle in the x-y plane
draw_circle(ax, 1:1:360, 0,'--mw-graphics-colorSpace-rgb-green','XZ',1.1*max(B(:))); % Circle in the x-z plane
draw_circle(ax, 1:1:360,90, '--mw-graphics-colorSpace-rgb-red','YZ',1.1*max(B(:))); % Circle in the y-z plane

% Spherical to cartesian
BZ  = B_shifted./max(max(B_shifted)).*cosd(theta_grid);
BX  = B_shifted./max(max(B_shifted)).*sind(theta_grid).*cosd(phi_grid);
BY  = B_shifted./max(max(B_shifted)).*sind(theta_grid).*sind(phi_grid);

% Plot surface
surf(ax,BX,BY,BZ,B, 'FaceColor','interp','LineStyle','none','FaceAlpha',1.0,'Tag','3D polar plot');

%cleanup
axis(ax,'vis3d');
axis(ax,'equal');
axis(ax,'off');
colormap(ax,jet(256));
colorbar
hold off

    function add_x_y_z_labels(axes1, rad)
        % Create pseudo-axes and x/y/z mark ticks
        XPos = rad;
        YPos = rad;
        ZPos = rad;

        plot3( axes1, [0,XPos],[0,0],[0,0],'r','LineWidth',1.5 );
        text(axes1,1.1*XPos,0,0, 'x');

        plot3( axes1, [0,0],[0,YPos],[0,0],'g','LineWidth',1.5 );
        text(axes1,0,1.05*YPos,0, 'y');

        plot3( axes1, [0,0],[0,0],[0,ZPos],'b','LineWidth',1.5 );
        text(axes1,0,0,1.05*ZPos, 'z');
    end

    function add_az_el_labels(axes1, rad)
        % Display azimuth/elevation

        % Create arrows to show azimuth and elevation variation
        XPos = rad;
        draw_arrow(axes1,[XPos 0],[XPos 0.1],1.5,0,'xy');
        text(axes1,1.2,0.12,0.0, texlabel('az'));
        draw_arrow(axes1,[XPos 0],[XPos 0.1],1.5,0, 'xz');
        text(axes1,1.2,-0.025,0.15, texlabel('el'));
    end% of add_az_el_labels

    function draw_arrow(axes1,startpoint,endpoint,headsize, offset, plane)

        v1 = headsize*(startpoint-endpoint)/2.5;

        theta      = 22.5*pi/180;
        theta2     = -1*22.5*pi/180;
        rotMatrix  = [cos(theta) -sin(theta) ; sin(theta) cos(theta)];
        rotMatrix1 = [cos(theta2) -sin(theta2) ; sin(theta2) cos(theta2)];

        v2 = v1*rotMatrix;
        v3 = v1*rotMatrix1;
        x1 = endpoint;
        x2 = x1 + v2;
        x3 = x1 + v3;
        if strcmpi(plane, 'xy')
            fill3(axes1,[x1(1) x2(1) x3(1)],[x1(2) x2(2) x3(2)],[offset offset offset],'k');
            plot3(axes1,[startpoint(1) endpoint(1)],[startpoint(2) endpoint(2)],      ...
                [offset offset],'linewidth',1.5,'color','k');
        elseif strcmpi(plane,'xz')
            fill3(axes1,[x1(1) x2(1) x3(1)],[offset offset offset],[x1(2) x2(2) x3(2)],'k');
            plot3(axes1,[startpoint(1) endpoint(1)],[offset offset],                  ...
                [startpoint(2) endpoint(2)],'linewidth',1.5,'color','k');
        end

    end% of draw arrow

    function draw_circle (axes1, theta, phi, color, Tag, rad)
        import matlab.graphics.internal.themes.specifyThemePropertyMappings
        [theta,phi] = meshgrid(theta, phi);

        % Spherical to cartesian
        Z  = rad./max(max(rad)).*cosd(theta);
        X  = rad./max(max(rad)).*sind(theta).*cosd(phi);
        Y  = rad./max(max(rad)).*sind(theta).*sind(phi);

        p = plot3(axes1,X,Y,Z,'LineWidth',2,'Tag',Tag);
        specifyThemePropertyMappings(p,'Color',color);

    end
end

