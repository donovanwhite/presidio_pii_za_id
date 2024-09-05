CREATE TABLE [dbo].[callcentre_comments](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[comments] [nvarchar](max) NULL,
	[modified_date] [datetime] NULL,
	[api_modified_date] [datetime] NULL,
 CONSTRAINT [PK_callcentre_comments] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE TABLE [dbo].[callcentre_comments_cog](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[comments] [nvarchar](max) NULL,
	[modified_date] [datetime] NULL,
	[api_modified_date] [datetime] NULL,
 CONSTRAINT [PK_callcentre_comments_cog] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

