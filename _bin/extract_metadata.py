#!/usr/bin/env python3
"""
Extract pitch, time signature, and tempo from MusicXML files.
"""
import xml.etree.ElementTree as ET
import sys
import json
from pathlib import Path

def extract_metadata(xml_file):
    """Extract metadata from a MusicXML file."""
    try:
        tree = ET.parse(xml_file)
        root = tree.getroot()
        
        # Define namespace
        ns = {'': 'http://www.musicxml.org/2002/elements'}
        
        # Extract pitch (key signature) from credit-words
        # Look for short text that looks like a key (last credit-words item is usually the key)
        pitch = "Unknown"
        all_credits = list(root.findall('.//credit-words'))
        if all_credits:
            # The last few credits typically contain metadata like key
            for credit in reversed(all_credits[-5:]):
                text = credit.text
                if text and len(text) <= 20:  # Key notations are typically short
                    # Check if it looks like a key (contains note names or common key indicators)
                    if any(term in text.lower() for term in ['major', 'minor', 'moll', 'dur', 'maj', '#', 'b♭', '♭']) or \
                       any(note in text for note in ['C', 'D', 'E', 'F', 'G', 'A', 'B', 'c', 'd', 'e', 'f', 'g', 'a', 'b']):
                        pitch = text
                        break
        
        # Extract time signature
        time_sig = "Unknown"
        beats = None
        beat_type = None
        for attributes in root.findall('.//attributes'):
            time_elem = attributes.find('time')
            if time_elem is not None:
                beats_elem = time_elem.find('beats')
                beat_type_elem = time_elem.find('beat-type')
                if beats_elem is not None and beat_type_elem is not None:
                    beats = beats_elem.text
                    beat_type = beat_type_elem.text
                    time_sig = f"{beats}/{beat_type}"
                    break
        
        # Extract tempo (BPM) from metronome or sound element
        tempo = "Unknown"
        for metronome in root.findall('.//metronome'):
            per_minute = metronome.find('per-minute')
            if per_minute is not None and per_minute.text:
                tempo = per_minute.text
                break
        
        # If no metronome found, try sound element
        if tempo == "Unknown":
            for sound in root.findall('.//sound'):
                if sound.get('tempo'):
                    tempo = sound.get('tempo')
                    break
        
        return {
            'pitch': pitch,
            'time': time_sig,
            'tempo': tempo if tempo != "Unknown" else ""
        }
    except Exception as e:
        print(f"Error processing {xml_file}: {e}", file=sys.stderr)
        return {'pitch': 'Unknown', 'time': 'Unknown', 'tempo': ''}

def main():
    if len(sys.argv) < 2:
        print("Usage: extract_metadata.py <xml_file>")
        sys.exit(1)
    
    xml_file = sys.argv[1]
    metadata = extract_metadata(xml_file)
    print(json.dumps(metadata))

if __name__ == '__main__':
    main()
