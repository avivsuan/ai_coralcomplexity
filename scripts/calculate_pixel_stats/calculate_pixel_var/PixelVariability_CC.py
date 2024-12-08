import os
import pandas as pd
from PIL import Image, ImageStat

def process_images(path, output_csv):
    df = pd.DataFrame(columns=['cell', 'RPixVar', 'GPixVar', 'BPixVar'])
    ext = '.tif'
    
    for myfile in os.listdir(path):
        if myfile.endswith(ext):
            input_image = Image.open(os.path.join(path, myfile))
            stat = ImageStat.Stat(input_image)
            print(myfile)
            print(stat.var)
            df = df.append({
                'cell': myfile,
                'RPixVar': stat.var[0],
                'GPixVar': stat.var[1],
                'BPixVar': stat.var[2]
            }, ignore_index=True)
    
    df.to_csv(output_csv, index=False)

# Define base paths and site structure
base_input_path = "Y:\\colorspace_transformations/gray"
sites = [
    {"site": "site_3_02_time04"},
    {"site": "site_3_04_time04"},
    {"site": "site_3_05_time08"},
    {"site": "site_3_06_time04"},
    {"site": "site_4_04_time07"},
    {"site": "site_4_05_time08"},
    {"site": "site_4_08_time07"},
    {"site": "site_4_11_time07"},
    {"site": "site_4_14_time06"},
    {"site": "site_NERR_time07"}
]

# Loop through each site and process images for both 'drone' and 'sfm' directories
for site in sites:
    for ortho_type in ['drone', 'sfm']:
        input_path = os.path.join(base_input_path, site["site"], ortho_type)
        output_csv = os.path.join(input_path, 'pix_values.csv')
        process_images(input_path, output_csv)
