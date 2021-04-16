STK.V.9.0
WrittenBy    StandardObjectCatalog
BEGIN Facility
Name        Svalsat_SG_1_STDN_SG1S
	BEGIN CentroidPosition
		DisplayCoords         Geodetic
		EcfLatitude           78.23072231
		EcfLongitude          15.38969589
		EcfAltitude           497.335
		DisplayAltRef         Ellipsoid
		AzElMask              AzElMaskFile: SG1S.aem
	END CentroidPosition
BEGIN Extensions
	BEGIN Graphics
		BEGIN Graphics
			ShowAzElAtRangeMask       On
			MinDisplayRange           0.0
			MaxDisplayRange           1000000.0
			NumAzElAtRangeMaskSteps   10
		END Graphics
	END Graphics
	BEGIN AccessConstraints
			LineOfSight     IncludeIntervals
			AzElMask        IncludeIntervals
	END AccessConstraints
	BEGIN Desc
		ShortText    22
Svalsat SG 1 STDN SG1S
		LongText    833
Name:           Svalsat SG 1 STDN SG1S
Country:        Norway
Location:       Longyearbyen, Svalbard
Status:         Active
Type:           GroundStation
Alternate name: SGS (Svalbard Ground Station)
Notes:          NASA# 1702, ESN# 30 || Equipment: S-bd X-bd, 11 meter, az-el  || Remarks: 12-97 EOS telem. sta.,(03-99),09

Sources:                       NASA Directory of Station Locations Jan 27 2010
               http://www.ksat.no/Products/Svalsat.htm
               http://www.ksat.no/Downloads/KSAT%20infrastructure%202005%20small.pdf
               http://scp.gsfc.nasa.gov/gn/norway.htm
               http://scp.gsfc.nasa.gov/gn/453-UG-002905.pdf
               http://eostation.scanex.ru/schedule/epgn.html
Last updated:   2009-12-14Antennas:       
  Type    :ParabolicReflector
  Diameter: 11.3 [Meters]

	END Desc
END Extensions
END Facility
