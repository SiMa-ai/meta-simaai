BUILD_NUMBER = "PRIVATE"

def  build_version(d): 
    print("getting sima build version")
    meta_simaai_path = ""
    major = ""
    minor = ""
    patch = ""



    # get build number
    build_number = d.getVar('BUILD_NUMBER')
    print(build_number)

    # get the meta-simaai layer path
    layers = (d.getVar("BBLAYERS") or "").split()
    for layer in layers:
        if "meta-simaai" in layer:
            meta_simaai_path = layer
            break

    print(meta_simaai_path)

    # get version number
    try:
        with open(meta_simaai_path + "/VERSION.in", 'r') as f:
            for line in f:
                if "major" in line :
                    major = line.split()[-1]
                elif "minor" in line :
                    minor = line.split()[-1]
                elif "patch" in line :
                    patch = line.split()[-1]
                else :
                    print("ERROR in version")
                    return
    except IOError:
       return

    version = major + "." + minor + "." + patch
    print(version)

    # get branch information
    branch_name = base_get_metadata_git_branch(meta_simaai_path, None).strip()
    print(branch_name)

    if "PRIVATE" not in build_number:
        build_number = "B" + build_number

    # prepare simaai version number
    sima_build_number = version + "_" + branch_name + "_" + build_number
    print(sima_build_number)
    return sima_build_number
