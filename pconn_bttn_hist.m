%% nc_preproc_artvec.m
% pconn_preproc_artvec

clear all

restoredefaultpath

fs = 1200;

% -------------------------------------------------------------------------
% VERSION 1
% -------------------------------------------------------------------------
v   = 4;
pad = 1200/2; % 500 ms
m   = 3; % which session: 1/2/3?
% -------------------------------------------------------------------------

indir = '/home/tpfeffer/pconn/proc/preproc/';

addpath('/home/tpfeffer/fieldtrip-20150318/')
addpath /home/tpfeffer/pconn/matlab/

ft_defaults
SUBJLIST =  [4 5 6 7 8 9 10 11 12 13 15 16 17 19 20 21 22 23 24];
%%

clear N_all

ord = pconn_randomization;

for isubj = 3

  for m = 1 : 3
      
    im = find(ord(isubj,:)==m);

    for ibl = 1 : 2
    
      if ~exist([indir sprintf('pconn_preproc_data_button_s%d_m%d_b%d_v%d.mat',isubj,im,ibl,v)])
        continue
      end
    
      disp(sprintf('Processing s%d m%d ...',isubj,m))
      
      load([indir sprintf('pconn_preproc_data_button_s%d_m%d_b%d_v%d.mat',isubj,im,ibl,v)])
      
      clear data
      
      cfg = [];
      cfg = cfgs;
      cfg.channel     = {'UPPT002'};
      cfg.continuous  = 'yes';
      trig            = ft_preprocessing(cfg); 
      
      dur   = diff(find(abs(diff(trig.trial{1}))>1));
      dur(dur<600)=[];
      
      
      if isempty(dur)
        N(:,ibl) = nan(length(0:2:50),1);
      else
        [N(:,ibl) B] = histc(dur./fs,0:2:50);
      end
      
      save(['~/pconn_bttn/proc/' sprintf('pconn_bttn_dur_s%d_b%d_m%d_v%d.mat',isubj,ibl,m,v)], 'dur') 
      save(['~/pconn_bttn/proc/' sprintf('pconn_bttn_trig_s%d_b%d_m%d_v%d.mat',isubj,ibl,m,v)], 'trig') 

      clear trig dur
      
    end
    
%     N_all(:,m,isubj) = nanmean(N,2);
    
  end
end

N_all = N_all(:,:,SUBJLIST);

save(['~/pconn_bttn/proc/' sprintf('pconn_bttn_hist_v%d.mat',v)], 'N_all')
error('!')

%%

SUBJLIST =  [4 5 6 7 8 9 11 12 13 15 16 17 19 20 21 22 23 24];

load ~/pconn_bttn/proc/pconn_bttn_hist_v4.mat

for isubj =  SUBJLIST
  for m = 1 : 3
    for iblock = 1 : 2
      
      load(['~/pconn_bttn/proc/' sprintf('pconn_bttn_dur_s%d_b%d_m%d_v%d.mat',isubj,iblock,m,v)], 'dur') 
      if ~isempty(dur)
        med_dur(iblock,m,isubj) = median(dur);
      else
        med_dur(iblock,m,isubj) = nan;
      end
      
    end    
  end
end

dur=squeeze(nanmean(med_dur(:,:,SUBJLIST)));

save(sprintf('~/pconn_bttn/proc/pconn_bttn_mediandur_v%d.mat',v),'dur');

%% 
load ~/pconn_bttn/proc/pconn_bttn_hist_v4.mat

figure; set(gcf,'color','white'); hold on

for isubj = 1 : 19
  for m = 1 : 3
  
    if m == 1
      plot(N_all(:,1,isubj),'r')
    elseif m == 2
      plot(N_all(:,2,isubj),'b')
    else
      plot(N_all(:,3,isubj),'m')
    end
    
  end
end


    




