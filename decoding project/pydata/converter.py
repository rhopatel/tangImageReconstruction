
import numpy as np
import scipy.io as sp;


mkA_NS = np.load("mkA_NS_data.npy")
mkA_PT = np.load("mkA_PT_data.npy")
mkE_NS = np.load("mkE_NS_data.npy")
mkE_PT = np.load("mkE_PT_data.npy")

mkE_PT_stimuli = np.load("mkE_PT_data.npy")
mkA_corr = np.load("monkey_A_correspondence.npy")

print(mkA_NS.shape);
print(mkA_PT.shape);
print(mkE_NS.shape);
print(mkE_PT.shape);


sp.savemat("mkA_NS_data.mat", {'mkA_NS': mkA_NS});
sp.savemat("mkA_PT_data.mat", {'mkA_PT': mkA_PT});
sp.savemat("mkE_NS_data.mat", {'mkE_NS': mkE_NS});
sp.savemat("mkE_PT_data.mat", {'mkE_PT': mkE_PT});


sp.savemat("mkE_PT_stimuli.mat", {'mkE_PT_stimuli': mkE_PT_stimuli});
sp.savemat("mkA_corr.mat", {'monkey_A_correspondence': mkA_corr});


print("done.")