import cv2 as cv
import glob
import os

def process_tiff_files(input_folder, output_folder):
    myfiles = glob.glob(input_folder + "/*.tif")
    print(myfiles)
    
    for i in myfiles:
        img_tiff = cv.imread(i)
        grayImageTiff = cv.cvtColor(img_tiff, cv.COLOR_BGR2GRAY)
        ext = os.path.basename(i)
        print(ext)
        output_path = os.path.join(output_folder, ext)
        cv.imwrite(output_path, grayImageTiff)

# Define your input and output directories
base_input_path = "Y:\\coral_ai_data"
base_output_path = "Y:\\colorspace_transformations\\gray"

sites = [
    {"site": "site_3_02_time04", "drone": "drone_ortho", "sfm": "sfm_ortho"},
    {"site": "site_3_04_time04", "drone": "drone_ortho", "sfm": "sfm_ortho"},
    {"site": "site_3_05_time08", "drone": "drone_ortho", "sfm": "sfm_ortho"},
    {"site": "site_3_06_time04", "drone": "drone_ortho", "sfm": "sfm_ortho"},
    {"site": "site_4_04_time07", "drone": "drone_ortho", "sfm": "sfm_ortho"},
    {"site": "site_4_05_time08", "drone": "drone_ortho", "sfm": "sfm_ortho"},
    {"site": "site_4_08_time07", "drone": "drone_ortho", "sfm": "sfm_ortho"},
    {"site": "site_4_11_time07", "drone": "drone_ortho", "sfm": "sfm_ortho"},
    {"site": "site_4_14_time06", "drone": "drone_ortho", "sfm": "sfm_ortho"},
    {"site": "site_NERR_time07", "drone": "drone_ortho", "sfm": "sfm_ortho"}
]

# Process each site
for site in sites:
    drone_input_folder = os.path.join(base_input_path, site["site"], site["drone"])
    sfm_input_folder = os.path.join(base_input_path, site["site"], site["sfm"])
    
    drone_output_folder = os.path.join(base_output_path, site["site"], "drone")
    sfm_output_folder = os.path.join(base_output_path, site["site"], "sfm")
    
    # Ensure output directories exist
    os.makedirs(drone_output_folder, exist_ok=True)
    os.makedirs(sfm_output_folder, exist_ok=True)
    
    # Process drone and SFM orthophotos
    process_tiff_files(drone_input_folder, drone_output_folder)
    process_tiff_files(sfm_input_folder, sfm_output_folder)
