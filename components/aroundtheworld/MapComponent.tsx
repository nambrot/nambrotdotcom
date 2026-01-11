'use client';

import { useEffect } from 'react';
import { MapContainer, TileLayer, Marker, useMap } from 'react-leaflet';
import L from 'leaflet';
import 'leaflet/dist/leaflet.css';
import { VideoLocation } from '@/data/videos';

// Fix for default marker icons in react-leaflet
const defaultIcon = L.icon({
  iconUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon.png',
  iconRetinaUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon-2x.png',
  shadowUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-shadow.png',
  iconSize: [25, 41],
  iconAnchor: [12, 41],
  popupAnchor: [1, -34],
  shadowSize: [41, 41],
});

// Nam's face marker icon
const namIcon = L.icon({
  iconUrl: '/images/namface.png',
  iconSize: [50, 50],
  iconAnchor: [25, 50],
});

interface MapComponentProps {
  videos: VideoLocation[];
  activeIndex: number;
  onMarkerClick: (index: number) => void;
  onNamMarkerClick: () => void;
  isZoomedIn: boolean;
}

function MapController({ 
  videos, 
  activeIndex, 
  isZoomedIn 
}: { 
  videos: VideoLocation[]; 
  activeIndex: number; 
  isZoomedIn: boolean;
}) {
  const map = useMap();
  
  useEffect(() => {
    if (videos.length === 0) return;
    
    if (isZoomedIn) {
      // Zoom in to current location when paused
      const coords = videos[activeIndex].coordinates;
      map.setView([coords[1], coords[0]], 10);
      // Pan left to make room for video player (like original: map.panBy L.point(-400, 0))
      map.panBy([-200, 0], { animate: false });
    } else {
      // Zoom out to world view when playing
      map.setView([-35, -130], 2);
    }
  }, [map, videos, activeIndex, isZoomedIn]);
  
  return null;
}

function NamMarker({ 
  videos, 
  activeIndex, 
  onClick 
}: { 
  videos: VideoLocation[]; 
  activeIndex: number; 
  onClick: () => void;
}) {
  const map = useMap();
  
  useEffect(() => {
    if (videos.length === 0) return;
    
    const coords = videos[activeIndex].coordinates;
    
    // Create or update the Nam marker
    const marker = L.marker([coords[1], coords[0]], {
      icon: namIcon,
      zIndexOffset: 100,
      title: 'Toggle zoom',
    }).addTo(map);
    
    marker.on('click', onClick);
    
    return () => {
      marker.remove();
    };
  }, [map, videos, activeIndex, onClick]);
  
  return null;
}

export default function MapComponent({ 
  videos, 
  activeIndex, 
  onMarkerClick, 
  onNamMarkerClick,
  isZoomedIn 
}: MapComponentProps) {
  return (
    <MapContainer
      center={[-35, -130]}
      zoom={2}
      id="map"
      style={{ width: '100%', height: '100%' }}
    >
      <TileLayer
        attribution='Map data &copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
        url="https://tile.openstreetmap.org/{z}/{x}/{y}.png"
      />
      
      {videos.map((video, index) => (
        <Marker
          key={video.id}
          position={[video.coordinates[1], video.coordinates[0]]}
          icon={defaultIcon}
          eventHandlers={{
            click: () => onMarkerClick(index),
          }}
        />
      ))}
      
      <NamMarker 
        videos={videos} 
        activeIndex={activeIndex} 
        onClick={onNamMarkerClick}
      />
      
      <MapController 
        videos={videos} 
        activeIndex={activeIndex} 
        isZoomedIn={isZoomedIn} 
      />
    </MapContainer>
  );
}
