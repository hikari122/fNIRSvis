function hb_data = smoothCBSI(hb_data, info, para)
ch_num = info.ad_ch_max/2;
for ch = 1:ch_num
    hb_frontal(:,ch) = hb_data.frontal.fil(2,:,ch);
    hbo_frontal(:,ch)=hb_data.frontal.fil(1,:,ch);
    hbt_frontal(:,ch)=hbo_frontal(:,ch)+hb_frontal(:,ch);
    
    hb_visual(:,ch)=hb_data.visual.fil(2,:,ch);
    hbo_visual(:,ch)=hb_data.visual.fil(1,:,ch);
    hbt_visual(:,ch)=hbo_visual(:,ch)+hb_visual(:,ch);
end

%CBSI
for ch=1:ch_num
    [CBSI_hbo_frontal(:,ch),CBSI_hb_frontal(:,ch)]=CBSI(hbo_frontal(:,ch),hb_frontal(:,ch));
    CBSI_hbt_frontal(:,ch)=CBSI_hb_frontal(:,ch)+CBSI_hbo_frontal(:,ch);
    [CBSI_hbo_visual(:,ch),CBSI_hb_visual(:,ch)]=CBSI(hbo_visual(:,ch),hb_visual(:,ch));
    CBSI_hbt_visual(:,ch)=CBSI_hbo_visual(:,ch)+CBSI_hb_visual(:,ch);
end
hb_data.frontal.CBSI(1,:,:) = CBSI_hbo_frontal;
hb_data.frontal.CBSI(2,:,:) = CBSI_hb_frontal;
hb_data.frontal.CBSI(3,:,:) = CBSI_hbt_frontal;
hb_data.visual.CBSI(1,:,:) = CBSI_hbo_visual;
hb_data.visual.CBSI(2,:,:) = CBSI_hb_visual;
hb_data.visual.CBSI(3,:,:) = CBSI_hbt_visual;
end

