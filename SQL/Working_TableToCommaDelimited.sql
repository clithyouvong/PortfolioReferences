Select RTRIM(
          LTRIM(
              STUFF(
                (
                  SELECT ', ' + T.Tag 
                  From   NEIEPTags T 
                  Where  T.ReferenceParentGuid=@NEIEPGalleryAlbumGuid 
                     AND T.ReferenceSubParentGuid=G.NEIEPGalleryGuid
                     AND T.[Application] = 'NEIEPGallery'
                  Order by T.Tag
                  FOR XML PATH(''), TYPE
                ).value('.[1]','nvarchar(max)'),
                1,1,''
              )
           )
        )  AS TagsList
