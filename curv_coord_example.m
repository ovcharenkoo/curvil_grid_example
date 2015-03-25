close all; clc; clear all;
%set(gca,'YDir','normal');
ny=10; %etamber of y lines
nx=20; %etamber of x lines
npml=10;

%Set rang
xmin=0;
xmax=100;
ymin=0;
ymax=10;
ymid=(ymax+ymin)/2;

% dksi=xmax/nx;
% deta=ymax/ny;
% ksipmls=dksi*2*npml;
% etapmls=deta*2*npml;
% xmax=xmax+ksipmls;
% ymax=ymax+etapmls;

x=linspace(xmin,xmax,nx+1);
y=sin(2*pi*x/max(x));
y=ymid+y;
y1=-ymid-sin(2*pi*x/max(x)-pi);
%Phys. domain
ksi=zeros(nx+1,ny+1);
eta=zeros(nx+1,ny+1);

%Comp. domain
xx=zeros(nx+1,ny+1);
yy=zeros(nx+1,ny+1);
dxx=1.0;
dyy=1.0;

for i=1:nx+1
    for j=1:ny+1
        xx(i,j)=dxx*(i-1);
        yy(i,j)=dyy*(j-1);
    end
end

%Calculate x-ksi in phys domain
for i=1:nx+1
        ksi(i,:)=x(1,i);
end

%subplot(2,2,2);
cksi=x;  %x in real space
nyr=round((ny)/2);
for i=1:ny+1
    if i<=nyr
        ceta=(i-1)*y/nyr; %y in real space
        eta(:,i)=ceta(1,:);
        %plot(cksi,ceta); hold on  %plot horizontal y lines
    else
        %disp('>');
        ceta=ymax+(ny-i+1)*y1/(ny-nyr); %y in real space
        eta(:,i)=ceta(1,:);
        %plot(cksi,ceta); hold on  %plot horizontal y lines
    end
%     if i==ny+1 %plot vertical lines for x
%         for j=1:nx
%             line([x(j),x(j)],[0,ceta(j)]); hold on
%         endend
%     end
end

% pmln=zeros(npml,ny+2*npml+1);
% pmls=zeros(npml,ny+2*npml+1);
% pmlw=zeros(nx+1, npml);
% pmle=zeros(nx+1, npml);
% 
% %fill the pmls with it's coordinates
% 
% 
% %Left and right PMLs
% ksi=[pmlw ksi pmle];
% eta=[pmlw eta pmle];
% 
% % %Top and bottom PMLs
%  ksi=[pmls; ksi; pmln];
%  eta=[pmls; eta; pmln];

% for i=1:nx+1
%     for j=1:ny+1
%         scatter(ksi(i,j),eta(i,j))
%     end
% end

%-------------------------------------------------------------------------
%Plot Cartesian grid
subplot(1,2,2)
title('Cartesian grid')
%plot grid lines
for i=2:nx+1
    for j=2:ny+1
        line([xx(i-1,j-1) xx(i-1,j-1)],[yy(i-1,j-1) yy(i-1,j)]); hold on; %vertical
        line([xx(i-1,j-1) xx(i,j-1)],[yy(i-1,j-1) yy(i-1,j-1)]); hold on; %horizontal
    end
end
line([xx(1,1) xx(end,1)],[max(yy(1,:)) max(yy(1,:))]);
line([xx(end,1) xx(end,1)],[yy(1,1) yy(1,end)]);
%--------------------------------------------------------------------------
%Plot curvilinear coordinates
subplot(1,2,1)
%plot grid lines
for i=1:ny+1
    plot(ksi(:,i),eta(:,i)); hold on
end
for i=1:nx+1
    line([ksi(i,1),ksi(i,1)],[0,eta(i,end)]); hold on
end
title('Curvilinear grid')


%--------------------------------------------------------------------------
%Derivatives and Jacobian
J=cell(nx,ny);
Ji=cell(nx,ny);
for i=2:nx+1
    for j=2:ny+1
        dksi_dx=(ksi(i,j)-ksi(i-1,j))/(xx(i,j)-xx(i-1,j));
        dksi_dy=(ksi(i,j)-ksi(i,j-1))/(yy(i,j)-yy(i,j-1));
        deta_dx=(eta(i,j)-eta(i-1,j))/(xx(i,j)-xx(i-1,j));
        deta_dy=(eta(i,j)-eta(i,j-1))/(yy(i,j)-yy(i,j-1));
        J{i-1,j-1}=[dksi_dx dksi_dy; deta_dx deta_dy];
        
        dx_dksi=(xx(i,j)-xx(i-1,j))/(ksi(i,j)-ksi(i-1,j));
        dy_dksi=(yy(i,j)-yy(i,j-1))/(ksi(i,j)-ksi(i,j-1));
        dx_deta=(xx(i,j)-xx(i-1,j))/(eta(i,j)-eta(i-1,j));
        dy_deta=(yy(i,j)-yy(i,j-1))/(eta(i,j)-eta(i,j-1));
        Ji{i-1,j-1}=[dx_dksi dx_deta; dy_dksi dy_deta];
    end
end
disp('Jacobian cell-array created');
disp('Finished');