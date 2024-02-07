#!/bin/bash

green="\033[0;32m"
orange="\033[0;33m"
red="\033[0;31m"
count=1
while getopts u: flag
do
    case "${flag}" in
        u) url=${OPTARG};;
    esac
done

echo "The program starts for $url domain to get subdomains in a second."
sleep 1
echo "Program started..."

while true;
do
    urlC="$url-$count"
    ((count++))
        if [ ! -d "./$urlC" ]; then
            mkdir "./$urlC" 
            break       
        else 
            urlC="$url-$count"      
            
        fi
done

theHarvesterFunction () {
    theHarvester -d $url -b all | sed -n '/Hosts found/,$p' | sed '1d;2d;3d;' | sed 's/\.com.*$/.com/' > ./$urlC/harvester.txt
    echo -e "${green}theHarvester is completed its job."
}

assetfinderFunction () {
    assetfinder $url > ./$urlC/assetfinder.txt
    sleep 1
    echo -e "${green}Assetfinder is completed its job."
}

subFinderFunction () {
    subfinder -d $url -all -silent > ./$urlC/subfinder.txt
    echo -e "${green}Subfinder is completed its job."
}

amassFunction () {
    amass enum -passive -d $url > ./$urlC/amass.txt
    echo -e "${green}Amass is completed its job."
}
waybackUnfurlFunction () {
    echo $url | waybackurls | unfurl -u domains > ./$urlC/waybackAndUnfurl.txt
    echo -e "${green}Waybackrurls and unfurl is completed its job."
}
sublisterFunction () {
    sublist3r -n -d $url | sed -n '/Total Unique Subdomains Found:/,$p' | sed "1d;" > ./$urlC/sublist3r.txt
    echo -e "${green}Sublist3r is completed its job."
}

combineLists () {
    echo "Lists are combining > allSubdomains.txt"
    cat ./$urlC/harvester.txt ./$urlC/amass.txt ./$urlC/subfinder.txt ./$urlC/assetfinder.txt ./$urlC/waybackAndUnfurl.txt ./$urlC/sublist3r.txt > ./$urlC/allSubdomains.txt
    echo "Lists are combined"
    sleep 1
    echo "Sorting and uniq processes starting. > uniqSubdomains.txt"
    sort -u ./$urlC/allSubdomains.txt | uniq > ./$urlC/uniqSubdomains.txt
    echo "Processes are completed."
}


theHarvesterFunction
assetfinderFunction
subFinderFunction
amassFunction
waybackUnfurlFunction
sublisterFunction
combineLists