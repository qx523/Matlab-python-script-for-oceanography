%%Calculate MOC in depth

LaVH=ncread('/Model output-OG_2100/LaVH1RHO.0085224960.nc','LaVH1RHO');
LaTr=ncread('/Model output-OG_2100/LaTR1RHO.0085224960.nc','LaTr1RHO');

dxC=ncread('/Model output-OG_2100/grid.nc','dxC');
x=ncread('/Model output-OG_2100/grid.nc','X');
y=ncread('/Model output-OG_2100/grid.nc','Y');
z=ncread('/Model output-OG_2100/grid.nc','Z');
hfacc=ncread('/Model output-OG_2100/grid.nc','HFacC');

tmask=hfacc;
tmask(tmask>0) = 1;
LaVH=LaVH(:,1:936,:);
tmask=hfacc;
tmask(tmask>0) = 1;
LaTr_x = sum(tmask.*LaTr,1) ./ sum(tmask,1); % get rid of impact from value of land
LaTr_x=squeeze(LaTr_x);

MOC_on_rho=nansum(LaVH.*dxC(1:126,:),1);
MOC_on_rho=squeeze(MOC_on_rho);
MOC_on_rho=cumsum(MOC_on_rho,2);

MOC_on_rho=MOC_on_rho/1e6;
density_layers=linspace(29,35,601);
density_layers=density_layers(1:600);



for i=1:1:936
   MOC_on_z_i=interp1(density_layers,MOC_on_rho(i,:),LaTr_x(i,:),'linear');
   MOC_on_z(:,i)=MOC_on_z_i;
end
max(MOC_on_z,[],'all')
min(MOC_on_z,[],'all')

figure;
set(gca,'Color',[0 0 0]);

pcolor(y,z,MOC_on_z);shading flat;hi=colormap(jet);
hi(31,:)=repmat([1 1 1],1,1);
colormap(hi);hi=R_B(512);colormap(hi);
%h1=colorbar;ylabel(h1, 'MOC (Sv)','fontsize',20)
caxis([-2.1 2.1])
set(gca,'FontSize',24)

xlabel('Latitude (\circN)','fontsize',24)
ylabel('Depth (m)','fontsize',24)
xlim([-60,60])
hold on
levels=[32,34,34.86,34.88,34.89,34.9,34.91];
contour(y,z,LaTr_x','ShowText','on','LevelList',levels)
