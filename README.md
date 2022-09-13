[Readme_En.docx](https://github.com/DehaiSong/FVCOMv4.0-MDOwave/files/9557300/Readme_En.docx)

A brief introduction of the MDO-WAVE module coupled with FVCOM V4.0 written by Dr. Dehai Song@Ocean University of China.

The MDO-WAVE was published by Mellor, Donelan and Oey (2008), which was firstly applied in POM.
Mellor, G. L., M. A. Donelan, and L.-Y. Oey (2008), A Surface Wave Model for Coupling with Numerical Ocean Circulation Models, Journal of Atmospheric and Oceanic Technology, 25(10), 1785-1807, doi:10.1175/2008jtecho573.1.

Then the module was implemented into FVCOM by Gao et al. (2018) to study the wave-current interactions on suspended sediment dynamics. 
Gao, G. D., X. H. Wang, D. Song, X. Bao, B. S. Yin, D. Z. Yang, Y. Ding, H. Li, F. Hou, and Z. Ren (2018), Effects of Wave–Current Interactions on Suspended-Sediment Dynamics during Strong Wave Events in Jiaozhou Bay, Qingdao, China, Journal of Physical Oceanography, 48(5), 1053-1078, doi:10.1175/JPO-D-17-0259.1.
https://journals.ametsoc.org/doi/suppl/10.1175/JPO-D-17-0259.1/suppl_file/10.1175_JPO-D-17-0259.s1.pdf   
Also, the following works:                               
Song, D., W. Wu, and Q. Li (2021), Effects of Wave–Current Interactions on Bay–Shelf Exchange, Journal of Physical Oceanography, 51(5), 1637-1654, doi:10.1175/jpo-d-20-0222.1.   
Jiang, Z., D. Song, Q. Wei, and Y. Ding (2022), Impact of Wave–Current Interactions on the Detachment of Low-Salinity Water From Changjiang River Plume and Its Subsequent Evolution, Frontiers in Marine Science, 9, doi:10.3389/fmars.2022.863540.

To couple the MDO-WAVE module into the FVCOM, the following files have been modified:     
adv_uv_edge_gcn.F, brough.F, extuv_edge.F, fvcom.F, internal_step.F, mod_force.F, mod_input.F, mod_main.F, mod_ncdio.F, mod_obcs.F, mod_report.F, mod_set_time.F, mod_startup.F, namelist.F, vdif_q.F, vdif_uv.F

Two FLAGs are given in the make.inc.                         
             FLAG_32 =  -DWAVE_ACTIVE                       
             FLAG_33 =  -DWCI_ACTIVE                        
FLAG_32 includes the following wave-current interactions: the wave-current combined bottom stress, the depth-dependent wave radiation stress, the Stokes drift velocity, and the mean current advection and refraction of wave energy.                            
FLAG_33 includes more interactions: 1) the breaking wave dissipation feeds into the TKE equation in vdif_q.F. Namely, the wave dissipation as a source term in the turbulence kinetic energy equation. 2) The wave induced stresses compete with turbulence Reynolds stresses in vdif_uv.F. Namely, the vertical transfer of wave-generated pressure transfer to the mean momentum equation (form drag).       

The wave parameter mmf = Number of angle segment (kseg) + 2 is defined in mod_main.F rather than in run.nml.            

The subroutine botdrag in mod_wave.F provides three ways to calculate the wave-current combined bottom stress, i.e., Signell et al. (1990), Madsen (1994) and Soulsby (1995). The user may choose one and commented the other two.

We also provides two kinds of boundary conditions for waves in mod_wave.F:
OBC_WAVE_NUDGING = T considering the open boundary swells, and
OBC_WAVE_NUDGING = F not considering the open boundary swells.
If the former, the significant wave height (hsig), wave direction (wdir), and peak wave period (tpek) should be provided at the open boundary nodes, which is written in a netcdf file, similar to the open boundary elevation. 

The file “specavs” should be placed to the file input folder.

In rum.nml, it must let WIND_ON = T            
If FLAG_32 =  -DWAVE_ACTIVE is uncommented in make.inc, then the following command lines should be added in run.nml, otherwise they should be removed or commented.

DTWS    =  EXTSTEP_SECONDS*ISPLIT, 
NC_WAVE_PARA    = F,         
NC_WAVE_STRESS  = F,       
NCAV_WAVE_PARA  = F,           
NCAV_WAVE_STRESS        = F,    
OBC_WAVE_NUDGING        = F,                       
OBC_WAVE_FILE   = tst_obc.nc,                     
OBC_WAVE_NUDGING_TIMESCALE      =  0.0000000E+00, 

An “Estuary” case is given for users’ reference to locate these command lines 

A wave namelist is given in run.nml as:

&NML_WAVE                     
 NITERA  = 3,                     
 BETA    = 2.2,                  ! spreading constant in fspr; higher beta = narrower spread but recommended value = 2,2 (non-d)                     
 CIN     = 370.0,                ! sin const. !constants in swin curve fit (non-d)                     
 SWCON   = 0.33,                 ! sin const. !constants in swin curve fit (non-d)                     
 ADIS    = 0.925,                ! sdis const. !empirically determined constants in sdisw term (non-d)                     
 BDIS    = 0.18e-4,              ! sdis const. !empirically determined constants in sdisw term (non-d)                     
 SWFCT   = 0.2,                  ! factor to decrease swell diss.  ! factor to reduce dissipation for swells (non-d)                     
 GAMA    = 0.73,                 ! depth-induced breaking const. !empirical constant in formulation of bdis2 (non-d)                     
 KPDMAX  = 3.0,                  ! maximum kpd                     
 EGYMIN  = 1.e-4,                ! minimum egy                     
 SGTMIN  = 0.10,                 ! minimum sgt                    
 DPMIN_GM  = 0.10                ! minimum depth for waves                           
/

If users find any bugs in the code or have any problems, please let me know through the email: songdh@ouc.edu.cn. We are happy to make FVCOM more robust and more efficient together. 
