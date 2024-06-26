% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/spZonalRast.R
\name{spZonalRast}
\alias{spZonalRast}
\title{Spatial - Extracts summary statistics by polygon (i.e., zone) for a raster.}
\usage{
spZonalRast(
  polyv,
  polyv_dsn = NULL,
  polyv.att = NULL,
  rastfn,
  rastfolder = NULL,
  bands = NULL,
  zonalstat,
  pixelfun = NULL,
  validate = FALSE,
  outname = NULL,
  showext = FALSE,
  rastlut = NULL,
  rast.NODATA = NULL,
  savedata = FALSE,
  savedata_opts = NULL
)
}
\arguments{
\item{polyv}{sf R object or String. Polygon data to identify zones. Can be a
spatial polygon object, full pathname to a shapefile, or name of a layer
within a database.}

\item{polyv_dsn}{String. Data source name (dsn; e.g., sqlite or shapefile
pathname) of zonal layer. The dsn varies by driver. See gdal OGR vector
formats (https://www.gdal.org/ogr_formats.html). Optional if polyv is sf
object.}

\item{polyv.att}{String. Name of attribute in polyv to identify zones for
summarizing raster statistics.}

\item{rastfn}{String or Raster. File name with extension, or raster
object.  Note: raster objects must be written to file.}

\item{rastfolder}{String. Name of the folder with raster layers. Optional.
Useful if all raster layers are in same folder.}

\item{bands}{Numeric vector. If rast is a multi-layer raster and only 1 or
some layers are desired, specify layer number(s) in a vector format. If
NULL, all layers are summed.}

\item{zonalstat}{String vector. Zonal statistic(s) to return for rasters
with continuous data ("mean", "sum", "majority", "minority", "variety",
"npixels") or rasters with discrete data ("count", "proportion").}

\item{pixelfun}{Function. A function to apply to the individual pixel values
before calculating sum and mean. The function should accept a single numeric
argument (pixel value) and return a single numeric argument.}

\item{validate}{Logical. If TRUE, validates polyv and clippolyv before 
clipping. Uses sf::st_make_valid with default parameters 
(geos_method='valid_structure', geos_keep_collapsed=FALSE).}

\item{outname}{String. Variable name for output. The output names will use
outname as a prefix to summary statistics (i.e., 'outname'.mean,
'outname'.sum).}

\item{showext}{Logical. If TRUE, layer extents are displayed in plot window.}

\item{rastlut}{Data frame. A look up table to recode raster values. Must be
2 columns: Column 1 with raster values and column 2 with recode values.}

\item{rast.NODATA}{Numeric. NODATA value (if not already defined) or other 
values to ignore. These values will be removed from output zonal table. 
NODATA values defined in raster are removed before zonal statistic 
calculations.}

\item{savedata}{Logical. If TRUE, the zonal data are saved to outfolder.}

\item{savedata_opts}{List. See help(savedata_options()) for a list
of options. Only used when savedata = TRUE. If out_layer = NULL,
default = 'zonalext'.}
}
\value{
\item{zonalext}{ Data frame. Zonal statistics by polygon attribute
(attribute). } \item{outname}{ String vector. Names of zonal statistic
variables generated in zonalext data frame. } \item{rasterfile}{ String
vector. Names of raster file(s) associated with zonal statistic. }

If savedata=TRUE, outdat data frame is saved to outfolder (Default name:
zonalext_'date'.csv).
}
\description{
Extracts summary statistics by polygon, or zone for a raster (single or
multi-band).
}
\details{
Use spZonalRast() to prompt for input.

If the projection of polyv is different than the projection of rast, the
polyv SpatialPolygons object is converted to the projection of rast (See
note about on-the-fly projection conversion).
}
\note{
rast.NODATA\cr NODATA values are raster pixel values that have no data
of interest, including pixels within the extent of the layer, but outside
the area of interest. Sometimes these pixels have been defined previously.
The defined NODATA pixels are imported to R as NULL values. When not
previously defined, the pixels outside the area of interest will be the
minimum or maximum value depending on the data type (e.g., 16-bit signed:
min=-32,768; max=32,768) or byte size (1 byte: min=0; max=255).  These
NODATA values will be added to the zonal statistic calculations if not
specified in rast.NODATA.

On-the-fly projection conversion\cr The spTransform (sf) method is used
for on-the-fly map projection conversion and datum transformation using
PROJ.4 arguments. Datum transformation only occurs if the +datum tag is
present in the both the from and to PROJ.4 strings. The +towgs84 tag is used
when no datum transformation is needed. PROJ.4 transformations assume NAD83
and WGS84 are identical unless other transformation parameters are
specified.  Be aware, providing inaccurate or incomplete CRS information may
lead to erroneous data shifts when reprojecting. See spTransform help
documentation for more details.
}
\examples{
\donttest{
# Set up data from `FIESTA`
WYbhdistfn <- system.file("extdata",
                          "sp_data/WYbighorn_districtbnd.shp",
                          package = "FIESTA")
demfn <- system.file("extdata",
                     "sp_data/WYbighorn_dem_250m.img",
                     package = "FIESTA")

# Import spatial data with `spImportSpatial`
WYbhdist <- spImportSpatial(WYbhdistfn)

# Extract mean and sum in `WYbhdist`
spZonalRast(polyv = WYbhdist, 
            polyv.att = "DISTRICTNA", 
            rastfn = demfn, 
            zonalstat = c("mean", "sum")) 
}
}
\author{
Tracey S. Frescino
}
\keyword{data}
