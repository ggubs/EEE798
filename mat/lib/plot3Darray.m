function plot3Darray(pos, arrRad, theta_inc, phi_inc, arrow_height, arrow_width)
%PLOT3DPATTERN Summary of this function goes here
%   Detailed explanation goes here

% axes setup

ax = axes();
daspect([1 1 1])
hold on
add_x_y_z_labels(ax, arrRad);
add_az_el_labels(ax, arrRad, arrow_height, arrow_width);
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
% startpoint, endpoint, color switch, arrow width, arrow height
arrow3([X_INC,Y_INC,Z_INC], [0,0,0], 'm-5', arrow_width, arrow_height); % from file exchange
axScale = 1.02;
xlim([-axScale*arrRad axScale*arrRad]); ylim([-axScale*arrRad axScale*arrRad]); zlim([-axScale*arrRad axScale*arrRad]);


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

    function add_az_el_labels(axes1, rad, h, w)
        % Display azimuth/elevation

        % Create arrows to show azimuth and elevation variation
        az_arrow_start = [rad, 0, 0];
        az_arrow_end = [rad, 0.2*rad, 0];

        el_arrow_start = [rad, 0, 0];
        el_arrow_end = [rad, 0, 0.2*rad,];

        arrow3(az_arrow_start, az_arrow_end, 'k-3', h/2, w);
        text(axes1,rad*1.02,rad*0.12,0.0, texlabel('az'));

        arrow3(el_arrow_start, el_arrow_end,'k-3', h/2, w);
        text(axes1,rad*1.02,rad*0.025,rad*0.15, texlabel('el'));
    end% of add_az_el_labels

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

