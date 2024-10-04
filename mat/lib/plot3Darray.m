function plot3Darray(pos, arrRad, theta_inc, phi_inc)
%PLOT3DPATTERN Summary of this function goes here
%   Detailed explanation goes here

% axes setup
ax = axes();
hold on
add_x_y_z_labels(ax, arrRad);
add_az_el_labels(ax, arrRad);
draw_circle(ax, 90, 1:1:360,'--mw-graphics-colorSpace-rgb-blue','XY_Circle',arrRad); % Circle in the x-y plane
draw_circle(ax, 1:1:360, 0,'--mw-graphics-colorSpace-rgb-green','XZ_Circle',arrRad); % Circle in the x-z plane
draw_circle(ax, 1:1:360,90, '--mw-graphics-colorSpace-rgb-red','YZ_Circle',arrRad); % Circle in the y-z plane

% draw elements
scatter3(pos(1,:),pos(2,:),pos(3,:), 'k', 'filled')

%cleanup
axis(ax,'vis3d');
axis(ax,'equal');
axis(ax,'off');

% draw incident wave (convert az/el to cartesian again)
Z_INC  = arrRad.*cosd(theta_inc);
X_INC  = arrRad.*sind(theta_inc).*cosd(phi_inc);
Y_INC  = arrRad.*sind(theta_inc).*sind(phi_inc);
daspect([1 1 1])
% startpoint, endpoint, color switch, arrow width, arrow height
arrow3([X_INC,Y_INC,Z_INC], [0,0,0], 'f-5', arrRad/7, arrRad/5); % from file exchange
hold off


%%% HELPER FUNCTIONS (Stolen and edited from some matlab internals)
    function add_x_y_z_labels(axes1, rad)
        % Create pseudo-axes and x/y/z mark ticks
        plot3( axes1, [0,rad],[0,0],[0,0],'r','LineWidth',1.5 );
        text(axes1,1.08*rad,0,0, 'x');

        plot3( axes1, [0,0],[0,rad],[0,0],'g','LineWidth',1.5 );
        text(axes1,0,1.08*rad,0, 'y');

        plot3( axes1, [0,0],[0,0],[0,rad],'b','LineWidth',1.5 );
        text(axes1,0,0,1.08*rad, 'z');
    end

    function add_az_el_labels(axes1, rad)
        % Display azimuth/elevation

        % Create arrows to show azimuth and elevation variation
        XPos = rad;
        az_arrow = [XPos 0 0;
                    XPos 0.2*rad 0;
                    0 0 0];
        arrow3(az_arrow);
        text(axes1,rad*1.05,rad*0.12,0.0, texlabel('az'));


        keyboard
        draw_arrow(axes1,[XPos 0],[XPos 0.2*rad],1.5,'xy');

        draw_arrow(axes1,[XPos 0],[XPos 0.2*rad],1.5, 'xz');
        text(axes1,rad*1.05,rad*0.025,rad*0.15, texlabel('el'));
    end% of add_az_el_labels

    function draw_arrow(axes1,startpoint,endpoint,headsize, plane)

        v1 = headsize*(startpoint-endpoint)/3;

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
            fill3(axes1,[x1(1) x2(1) x3(1)],[x1(2) x2(2) x3(2)],[0 0 0],'k');
            plot3(axes1,[startpoint(1) endpoint(1)],[startpoint(2) endpoint(2)],      ...
                [0 0],'linewidth',1.5,'color','k');
        elseif strcmpi(plane,'xz')
            fill3(axes1,[x1(1) x2(1) x3(1)],[0 0 0],[x1(2) x2(2) x3(2)],'k');
            plot3(axes1,[startpoint(1) endpoint(1)],[0 0],                  ...
                [startpoint(2) endpoint(2)],'linewidth',1.5,'color','k');
        end

    end% of draw arrow

    function draw_circle (axes1, theta, phi, color, Tag, r)
        import matlab.graphics.internal.themes.specifyThemePropertyMappings
        [theta,phi] = meshgrid(theta, phi);

        % Spherical to cartesian
        Z  = r.*cosd(theta);
        X  = r.*sind(theta).*cosd(phi);
        Y  = r.*sind(theta).*sind(phi);

        p = plot3(axes1,X,Y,Z,'LineWidth',2,'Tag',Tag);
        specifyThemePropertyMappings(p,'Color',color);

    end
end

