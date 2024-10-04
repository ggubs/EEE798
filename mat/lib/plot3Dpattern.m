function plot3Dpattern(B1, theta1, phi1)
%PLOT3DPATTERN Summary of this function goes here

% Shift the beampattern to the origin
[theta_grid,phi_grid] = meshgrid(theta1, phi1);
B = reshape(B1,length(phi1),length(theta1));
B_shifted = B - min(B(:));

ax = axes();
daspect([1 1 1])
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

% rescale plot
axScale = 1.02;
arrRad = max(B_shifted(:));
xlim([-axScale*arrRad axScale*arrRad]); ylim([-axScale*arrRad axScale*arrRad]); zlim([-axScale*arrRad axScale*arrRad]);

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
        az_arrow_start = [rad, 0, 0];
        az_arrow_end = [rad, 0.2*rad, 0];

        el_arrow_start = [rad, 0, 0];
        el_arrow_end = [rad, 0, 0.2*rad,];

        arrow3(az_arrow_start, az_arrow_end, 'k-3');
        text(axes1,rad*1.02,rad*0.12,0.0, texlabel('az'));

        arrow3(el_arrow_start, el_arrow_end,'k-3');
        text(axes1,rad*1.02,rad*0.025,rad*0.15, texlabel('el'));
    end% of add_az_el_labels

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

