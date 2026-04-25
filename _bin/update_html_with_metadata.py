#!/usr/bin/env python3
"""
Update HTML files with metadata from XML files.
Adds pitch, time, and tempo to song entries in the YAML front matter.
"""
import re
import json
import yaml
from pathlib import Path
from subprocess import run, PIPE
import sys

def extract_metadata_for_song(song_info):
    """Extract metadata for a song given its directory and basename."""
    song_dir = song_info.get('dir')
    basename = song_info.get('basename')
    
    if not song_dir or not basename:
        return None
    
    # Try to find the XML file
    song_path = Path(song_dir)
    xml_file = song_path / f"{basename}.xml"
    
    if not xml_file.exists():
        # Try alternative patterns
        for xml in song_path.glob("*.xml"):
            if basename in xml.name:
                xml_file = xml
                break
    
    if not xml_file.exists():
        return None
    
    try:
        result = run(['python3', '_bin/extract_metadata.py', str(xml_file)], 
                    capture_output=True, text=True, timeout=5)
        if result.returncode == 0:
            return json.loads(result.stdout)
    except Exception as e:
        print(f"Error extracting metadata for {xml_file}: {e}", file=sys.stderr)
    
    return None

def update_html_file(html_path):
    """Update an HTML file with metadata for all songs."""
    with open(html_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Extract front matter
    match = re.match(r'^(---\n)(.*?)(---\n)', content, re.DOTALL)
    if not match:
        print(f"No front matter found in {html_path}", file=sys.stderr)
        return False
    
    fm_start = match.start()
    fm_end = match.end()
    fm_content = match.group(2)
    body = content[fm_end:]
    
    try:
        # Parse YAML front matter
        fm_data = yaml.safe_load(fm_content)
        
        if not isinstance(fm_data.get('songs'), list):
            print(f"No songs list found in {html_path}", file=sys.stderr)
            return False
        
        # Update each song with metadata
        for song in fm_data['songs']:
            metadata = extract_metadata_for_song(song)
            if metadata:
                song['pitch'] = metadata['pitch']
                song['time'] = metadata['time']
                song['tempo'] = metadata['tempo']
                print(f"Updated {song['name']}: pitch={metadata['pitch']}, time={metadata['time']}, tempo={metadata['tempo']}")
        
        # Generate new front matter
        new_fm = yaml.dump(fm_data, default_flow_style=False, allow_unicode=True, sort_keys=False)
        new_content = f"---\n{new_fm}---\n{body}"
        
        with open(html_path, 'w', encoding='utf-8') as f:
            f.write(new_content)
        
        print(f"Updated {html_path}")
        return True
    except Exception as e:
        print(f"Error processing {html_path}: {e}", file=sys.stderr)
        return False

def main():
    # Find all HTML files with front matter that might contain songs
    html_files = [
        Path('valborg.html'),
        Path('valborg_bari.html'),
    ]
    
    for html_file in html_files:
        if html_file.exists():
            update_html_file(html_file)
        else:
            print(f"File not found: {html_file}", file=sys.stderr)

if __name__ == '__main__':
    main()
