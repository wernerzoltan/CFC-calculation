create or replace PACKAGE BODY CFC AS  
V_AGAZAT_IMP T_AGAZAT_IMP;
V_PIM_INPUT T_PIM_INPUT;
v_pim t_pim;
v_out_eszkozcsp t_out_eszkozcsp;
v_out_szektor t_out_szektor;
v_out_alszektor t_out_alszektor;
v_out_name t_out_name;

sum_1999 VARCHAR2(50);
sum_unch VARCHAR2(50);
evszam VARCHAR2(5);

-- melyik sémába töltsük be az adatokat
v_out_schema VARCHAR(10) := 'PKD';

v_pim_create VARCHAR2(10000) := '("OUTPUT" VARCHAR2(5), "SZEKTOR" VARCHAR2(100 BYTE), "ALSZEKTOR" VARCHAR2(100 BYTE), "ALSZEKTOR2" VARCHAR2(100 BYTE), "ESZKOZCSP" VARCHAR2(100 BYTE), "AGAZAT" VARCHAR2(30 BYTE),"EGYEB" VARCHAR2(30 BYTE), "Y1780" NUMBER,	"Y1781" NUMBER,	"Y1782" NUMBER,	"Y1783" NUMBER,	"Y1784" NUMBER,	"Y1785" NUMBER,	"Y1786" NUMBER,	"Y1787" NUMBER,	"Y1788" NUMBER,	"Y1789" NUMBER,	"Y1790" NUMBER,	"Y1791" NUMBER,	"Y1792" NUMBER,	"Y1793" NUMBER,	"Y1794" NUMBER,	"Y1795" NUMBER,	"Y1796" NUMBER,	"Y1797" NUMBER,	"Y1798" NUMBER,	"Y1799" NUMBER,	"Y1800" NUMBER,	"Y1801" NUMBER,	"Y1802" NUMBER,	"Y1803" NUMBER,	"Y1804" NUMBER,	"Y1805" NUMBER,	"Y1806" NUMBER,	"Y1807" NUMBER,	"Y1808" NUMBER,	"Y1809" NUMBER,	"Y1810" NUMBER,	"Y1811" NUMBER,	"Y1812" NUMBER,	"Y1813" NUMBER,	"Y1814" NUMBER,	"Y1815" NUMBER,	"Y1816" NUMBER,	"Y1817" NUMBER,	"Y1818" NUMBER,	"Y1819" NUMBER,	"Y1820" NUMBER,	"Y1821" NUMBER,	"Y1822" NUMBER,	"Y1823" NUMBER,	"Y1824" NUMBER,	"Y1825" NUMBER,	"Y1826" NUMBER,	"Y1827" NUMBER,	"Y1828" NUMBER,	"Y1829" NUMBER,	"Y1830" NUMBER,	"Y1831" NUMBER,	"Y1832" NUMBER,	"Y1833" NUMBER,	"Y1834" NUMBER,	"Y1835" NUMBER,	"Y1836" NUMBER,	"Y1837" NUMBER,	"Y1838" NUMBER,	"Y1839" NUMBER,	"Y1840" NUMBER,	"Y1841" NUMBER,	"Y1842" NUMBER,	"Y1843" NUMBER,	"Y1844" NUMBER,	"Y1845" NUMBER,	"Y1846" NUMBER,	"Y1847" NUMBER,	"Y1848" NUMBER,	"Y1849" NUMBER,	"Y1850" NUMBER,	"Y1851" NUMBER,	"Y1852" NUMBER,	"Y1853" NUMBER,	"Y1854" NUMBER,	"Y1855" NUMBER,	"Y1856" NUMBER,	"Y1857" NUMBER,	"Y1858" NUMBER,	"Y1859" NUMBER,	"Y1860" NUMBER,	"Y1861" NUMBER,	"Y1862" NUMBER,	"Y1863" NUMBER,	"Y1864" NUMBER,	"Y1865" NUMBER,	"Y1866" NUMBER,	"Y1867" NUMBER,	"Y1868" NUMBER,	"Y1869" NUMBER,	"Y1870" NUMBER,	"Y1871" NUMBER,	"Y1872" NUMBER,	"Y1873" NUMBER,	"Y1874" NUMBER,	"Y1875" NUMBER,	"Y1876" NUMBER,	"Y1877" NUMBER,	"Y1878" NUMBER,	"Y1879" NUMBER,	"Y1880" NUMBER,	"Y1881" NUMBER,	"Y1882" NUMBER,	"Y1883" NUMBER,	"Y1884" NUMBER,	"Y1885" NUMBER,	"Y1886" NUMBER,	"Y1887" NUMBER,	"Y1888" NUMBER,	"Y1889" NUMBER,	"Y1890" NUMBER,	"Y1891" NUMBER,	"Y1892" NUMBER,	"Y1893" NUMBER,	"Y1894" NUMBER,	"Y1895" NUMBER,	"Y1896" NUMBER,	"Y1897" NUMBER,	"Y1898" NUMBER,	"Y1899" NUMBER, "Y1900" NUMBER, "Y1901" NUMBER, "Y1902" NUMBER, "Y1903" NUMBER, "Y1904" NUMBER, "Y1905" NUMBER, "Y1906" NUMBER, "Y1907" NUMBER, "Y1908" NUMBER, "Y1909" NUMBER, "Y1910" NUMBER, "Y1911" NUMBER, "Y1912" NUMBER, "Y1913" NUMBER, "Y1914" NUMBER, "Y1915" NUMBER, "Y1916" NUMBER, "Y1917" NUMBER, "Y1918" NUMBER, "Y1919" NUMBER, "Y1920" NUMBER, "Y1921" NUMBER, "Y1922" NUMBER, "Y1923" NUMBER, "Y1924" NUMBER, "Y1925" NUMBER, "Y1926" NUMBER, "Y1927" NUMBER, "Y1928" NUMBER, "Y1929" NUMBER, "Y1930" NUMBER, "Y1931" NUMBER, "Y1932" NUMBER, "Y1933" NUMBER, "Y1934" NUMBER, "Y1935" NUMBER, "Y1936" NUMBER, "Y1937" NUMBER, "Y1938" NUMBER, "Y1939" NUMBER, "Y1940" NUMBER, "Y1941" NUMBER, "Y1942" NUMBER, "Y1943" NUMBER, "Y1944" NUMBER, "Y1945" NUMBER, "Y1946" NUMBER, "Y1947" NUMBER, "Y1948" NUMBER, "Y1949" NUMBER, "Y1950" NUMBER, "Y1951" NUMBER, "Y1952" NUMBER, "Y1953" NUMBER, "Y1954" NUMBER, "Y1955" NUMBER, "Y1956" NUMBER, "Y1957" NUMBER, "Y1958" NUMBER, "Y1959" NUMBER, "Y1960" NUMBER, "Y1961" NUMBER, "Y1962" NUMBER, "Y1963" NUMBER, "Y1964" NUMBER, "Y1965" NUMBER, "Y1966" NUMBER, "Y1967" NUMBER, "Y1968" NUMBER, "Y1969" NUMBER, "Y1970" NUMBER, "Y1971" NUMBER, "Y1972" NUMBER, "Y1973" NUMBER, "Y1974" NUMBER, "Y1975" NUMBER, "Y1976" NUMBER, "Y1977"NUMBER, "Y1978" NUMBER, "Y1979" NUMBER, "Y1980" NUMBER, "Y1981" NUMBER, "Y1982" NUMBER, "Y1983" NUMBER, "Y1984" NUMBER, "Y1985" NUMBER, "Y1986" NUMBER, "Y1987" NUMBER, "Y1988" NUMBER, "Y1989" NUMBER, "Y1990" NUMBER, "Y1991" NUMBER, "Y1992" NUMBER, "Y1993" NUMBER, "Y1994" NUMBER, "Y1995" NUMBER, "Y1996" NUMBER, "Y1997" NUMBER, "Y1998" NUMBER, "Y1999" NUMBER, "Y2000" NUMBER, "Y2001" NUMBER, "Y2002" NUMBER, "Y2003" NUMBER, "Y2004" NUMBER, "Y2005" NUMBER, "Y2006" NUMBER, "Y2007" NUMBER, "Y2008" NUMBER, "Y2009" NUMBER, "Y2010" NUMBER, "Y2011" NUMBER, "Y2012" NUMBER, "Y2013" NUMBER, "Y2014" NUMBER, "Y2015" NUMBER, "Y2016" NUMBER, "Y2017" NUMBER, "YSUM" NUMBER,  "YSUM_AKT" NUMBER, "YSUM_UNCH" NUMBER)';  

v_pim_create_out VARCHAR2(10000) := 'OUTPUT,  SZEKTOR, ALSZEKTOR, ALSZEKTOR2, ESZKOZCSP, AGAZAT, EGYEB,

Y1780 ,	Y1781 ,	Y1782 ,	Y1783 ,	Y1784 ,	Y1785 ,	Y1786 ,	Y1787 ,	Y1788 ,	Y1789 ,	Y1790 ,	Y1791 ,	Y1792 ,	Y1793 ,	Y1794 ,	Y1795 ,	Y1796 ,	Y1797 ,	Y1798 ,	Y1799 ,	Y1800 ,	Y1801 ,	Y1802 ,	Y1803 ,	Y1804 ,	Y1805 ,	Y1806 ,	Y1807 ,	Y1808 ,	Y1809 ,	Y1810 ,	Y1811 ,	Y1812 ,	Y1813 ,	Y1814 ,	Y1815 ,	Y1816 ,	Y1817 ,	Y1818 ,	Y1819 ,	Y1820 ,	Y1821 ,	Y1822 ,	Y1823 ,	Y1824 ,	Y1825 ,	Y1826 ,	Y1827 ,	Y1828 ,	Y1829 ,	Y1830 ,	Y1831 ,	Y1832 ,	Y1833 ,	Y1834 ,	Y1835 ,	Y1836 ,	Y1837 ,	Y1838 ,	Y1839 ,	Y1840 ,	Y1841 ,	Y1842 ,	Y1843 ,	Y1844 ,	Y1845 ,	Y1846 ,	Y1847 ,	Y1848 ,	Y1849 ,	Y1850 ,	Y1851 ,	Y1852 ,	Y1853 ,	Y1854 ,	Y1855 ,	Y1856 ,	Y1857 ,	Y1858 ,	Y1859 ,	Y1860 ,	Y1861 ,	Y1862 ,	Y1863 ,	Y1864 ,	Y1865 ,	Y1866 ,	Y1867 ,	Y1868 ,	Y1869 ,	Y1870 ,	Y1871 ,	Y1872 ,	Y1873 ,	Y1874 ,	Y1875 ,	Y1876 ,	Y1877 ,	Y1878 ,	Y1879 ,	Y1880 ,	Y1881 ,	Y1882 ,	Y1883 ,	Y1884 ,	Y1885 ,	Y1886 ,	Y1887 ,	Y1888 ,	Y1889 ,	Y1890 ,	Y1891 ,	Y1892 ,	Y1893 ,	Y1894 ,	Y1895 ,	Y1896 ,	Y1897 ,	Y1898 ,	Y1899 ,
 Y1900 , Y1901 , Y1902 , Y1903 , Y1904 , Y1905 , Y1906 , Y1907 , Y1908 , Y1909 , Y1910 , Y1911 , Y1912 , Y1913 , Y1914 , Y1915 , Y1916 , Y1917 , Y1918 , Y1919 , Y1920 , Y1921 , Y1922 , Y1923 , Y1924 , Y1925 , Y1926 , Y1927 , Y1928 , Y1929 , Y1930 , Y1931 , Y1932 , Y1933 , Y1934 , Y1935 , Y1936 , Y1937 , Y1938 , Y1939 , Y1940 , Y1941 , Y1942 , Y1943 , Y1944 , Y1945 , Y1946 , Y1947 , Y1948 , Y1949 , Y1950 , Y1951 , Y1952 , Y1953 , Y1954 , Y1955 , Y1956 , Y1957 , Y1958 , Y1959 , Y1960 , Y1961 , Y1962 , Y1963 , Y1964 , Y1965 , Y1966 , Y1967 , Y1968 , Y1969 , Y1970 , Y1971 , Y1972 , Y1973 , Y1974 , Y1975 , Y1976 , Y1977, Y1978 , Y1979 , Y1980 , Y1981 , Y1982 , Y1983 , Y1984 , Y1985 , Y1986 , Y1987 , Y1988 , Y1989 , Y1990 , Y1991 , Y1992 , Y1993 , Y1994 , Y1995 , Y1996 , Y1997 , Y1998 , Y1999 , Y2000 , Y2001 , Y2002 , Y2003 , Y2004 , Y2005 , Y2006 , Y2007 , Y2008 , Y2009 , Y2010 , Y2011 , Y2012 , Y2013 , Y2014 , Y2015 , Y2016 , Y2017,  YSUM ,  YSUM_AKT, YSUM_UNCH ) 
 SELECT  OUTPUT, SZEKTOR, ALSZEKTOR, ALSZEKTOR2, ESZKOZCSP, AGAZAT, EGYEB, Y1780, Y1781 ,	Y1782 ,	Y1783 ,	Y1784 ,	Y1785 ,	Y1786 ,	Y1787 ,	Y1788 ,	Y1789 ,	Y1790 ,	Y1791 ,	Y1792 ,	Y1793 ,	Y1794 ,	Y1795 ,	Y1796 ,	Y1797 ,	Y1798 ,	Y1799 ,	Y1800 ,	Y1801 ,	Y1802 ,	Y1803 ,	Y1804 ,	Y1805 ,	Y1806 ,	Y1807 ,	Y1808 ,	Y1809 ,	Y1810 ,	Y1811 ,	Y1812 ,	Y1813 ,	Y1814 ,	Y1815 ,	Y1816 ,	Y1817 ,	Y1818 ,	Y1819 ,	Y1820 ,	Y1821 ,	Y1822 ,	Y1823 ,	Y1824 ,	Y1825 ,	Y1826 ,	Y1827 ,	Y1828 ,	Y1829 ,	Y1830 ,	Y1831 ,	Y1832 ,	Y1833 ,	Y1834 ,	Y1835 ,	Y1836 ,	Y1837 ,	Y1838 ,	Y1839 ,	Y1840 ,	Y1841 ,	Y1842 ,	Y1843 ,	Y1844 ,	Y1845 ,	Y1846 ,	Y1847 ,	Y1848 ,	Y1849 ,	Y1850 ,	Y1851 ,	Y1852 ,	Y1853 ,	Y1854 ,	Y1855 ,	Y1856 ,	Y1857 ,	Y1858 ,	Y1859 ,	Y1860 ,	Y1861 ,	Y1862 ,	Y1863 ,	Y1864 ,	Y1865 ,	Y1866 ,	Y1867 ,	Y1868 ,	Y1869 ,	Y1870 ,	Y1871 ,	Y1872 ,	Y1873 ,	Y1874 ,	Y1875 ,	Y1876 ,	Y1877 ,	Y1878 ,	Y1879 ,	Y1880 ,	Y1881 ,	Y1882 ,	Y1883 ,	Y1884 ,	Y1885 ,	Y1886 ,	Y1887 ,	Y1888 ,	Y1889 ,	Y1890 ,	Y1891 ,	Y1892 ,	Y1893 ,	Y1894 ,	Y1895 ,	Y1896 ,	Y1897 ,	Y1898 ,	Y1899 , Y1900 , Y1901 , Y1902 , Y1903 , Y1904 , Y1905 , Y1906 , Y1907 , Y1908 , Y1909 , Y1910 , Y1911 , Y1912 , Y1913 , Y1914 , Y1915 , Y1916 , Y1917 , Y1918 , Y1919 , Y1920 , Y1921 , Y1922 , Y1923 , Y1924 , Y1925 , Y1926 , Y1927 , Y1928 , Y1929 , Y1930 , Y1931 , Y1932 , Y1933 , Y1934 , Y1935 , Y1936 , Y1937 , Y1938 , Y1939 , Y1940 , Y1941 , Y1942 , Y1943 , Y1944 , Y1945 , Y1946 , Y1947 , Y1948 , Y1949 , Y1950 , Y1951 , Y1952 , Y1953 , Y1954 , Y1955 , Y1956 , Y1957 , Y1958 , Y1959 , Y1960 , Y1961 , Y1962 , Y1963 , Y1964 , Y1965 , Y1966 , Y1967 , Y1968 , Y1969 , Y1970 , Y1971 , Y1972 , Y1973 , Y1974 , Y1975 , Y1976 , Y1977, Y1978 , Y1979 , Y1980 , Y1981 , Y1982 , Y1983 , Y1984 , Y1985 , Y1986 , Y1987 , Y1988 , Y1989 , Y1990 , Y1991 , Y1992 , Y1993 , Y1994 , Y1995 , Y1996 , Y1997 , Y1998 , Y1999 , Y2000 , Y2001 , Y2002 , Y2003 , Y2004 , Y2005 , Y2006 , Y2007 , Y2008 , Y2009 , Y2010 , Y2011 , Y2012 , Y2013 , Y2014 , Y2015 , Y2016 , Y2017, YSUM ,  YSUM_AKT, YSUM_UNCH';

v_pim_create_out_cfc VARCHAR2(10000) := 'OUTPUT,  SZEKTOR, ALSZEKTOR, ALSZEKTOR2, ESZKOZCSP, AGAZAT, EGYEB, Y1781 ,	Y1782 ,	Y1783 ,	Y1784 ,	Y1785 ,	Y1786 ,	Y1787 ,	Y1788 ,	Y1789 ,	Y1790 ,	Y1791 ,	Y1792 ,	Y1793 ,	Y1794 ,	Y1795 ,	Y1796 ,	Y1797 ,	Y1798 ,	Y1799 ,	Y1800 ,	Y1801 ,	Y1802 ,	Y1803 ,	Y1804 ,	Y1805 ,	Y1806 ,	Y1807 ,	Y1808 ,	Y1809 ,	Y1810 ,	Y1811 ,	Y1812 ,	Y1813 ,	Y1814 ,	Y1815 ,	Y1816 ,	Y1817 ,	Y1818 ,	Y1819 ,	Y1820 ,	Y1821 ,	Y1822 ,	Y1823 ,	Y1824 ,	Y1825 ,	Y1826 ,	Y1827 ,	Y1828 ,	Y1829 ,	Y1830 ,	Y1831 ,	Y1832 ,	Y1833 ,	Y1834 ,	Y1835 ,	Y1836 ,	Y1837 ,	Y1838 ,	Y1839 ,	Y1840 ,	Y1841 ,	Y1842 ,	Y1843 ,	Y1844 ,	Y1845 ,	Y1846 ,	Y1847 ,	Y1848 ,	Y1849 ,	Y1850 ,	Y1851 ,	Y1852 ,	Y1853 ,	Y1854 ,	Y1855 ,	Y1856 ,	Y1857 ,	Y1858 ,	Y1859 ,	Y1860 ,	Y1861 ,	Y1862 ,	Y1863 ,	Y1864 ,	Y1865 ,	Y1866 ,	Y1867 ,	Y1868 ,	Y1869 ,	Y1870 ,	Y1871 ,	Y1872 ,	Y1873 ,	Y1874 ,	Y1875 ,	Y1876 ,	Y1877 ,	Y1878 ,	Y1879 ,	Y1880 ,	Y1881 ,	Y1882 ,	Y1883 ,	Y1884 ,	Y1885 ,	Y1886 ,	Y1887 ,	Y1888 ,	Y1889 ,	Y1890 ,	Y1891 ,	Y1892 ,	Y1893 ,	Y1894 ,	Y1895 ,	Y1896 ,	Y1897 ,	Y1898 ,	Y1899 , Y1900, Y1901 , Y1902 , Y1903 , Y1904 , Y1905 , Y1906 , Y1907 , Y1908 , Y1909 , Y1910 , Y1911 , Y1912 , Y1913 , Y1914 , Y1915 , Y1916 , Y1917 , Y1918 , Y1919 , Y1920 , Y1921 , Y1922 , Y1923 , Y1924 , Y1925 , Y1926 , Y1927 , Y1928 , Y1929 , Y1930 , Y1931 , Y1932 , Y1933 , Y1934 , Y1935 , Y1936 , Y1937 , Y1938 , Y1939 , Y1940 , Y1941 , Y1942 , Y1943 , Y1944 , Y1945 , Y1946 , Y1947 , Y1948 , Y1949 , Y1950 , Y1951 , Y1952 , Y1953 , Y1954 , Y1955 , Y1956 , Y1957 , Y1958 , Y1959 , Y1960 , Y1961 , Y1962 , Y1963 , Y1964 , Y1965 , Y1966 , Y1967 , Y1968 , Y1969 , Y1970 , Y1971 , Y1972 , Y1973 , Y1974 , Y1975 , Y1976 , Y1977, Y1978 , Y1979 , Y1980 , Y1981 , Y1982 , Y1983 , Y1984 , Y1985 , Y1986 , Y1987 , Y1988 , Y1989 , Y1990 , Y1991 , Y1992 , Y1993 , Y1994 , Y1995 , Y1996 , Y1997 , Y1998 , Y1999 , Y2000 , Y2001 , Y2002 , Y2003 , Y2004 , Y2005 , Y2006 , Y2007 , Y2008 , Y2009 , Y2010 , Y2011 , Y2012 , Y2013 , Y2014 , Y2015 , Y2016 , Y2017, YSUM ,  YSUM_AKT, YSUM_UNCH ) SELECT  OUTPUT, SZEKTOR, ALSZEKTOR, ALSZEKTOR2, ESZKOZCSP, AGAZAT, EGYEB, Y1780, Y1781 ,  Y1782 ,	Y1783 ,	Y1784 ,	Y1785 ,	Y1786 ,	Y1787 ,	Y1788 ,	Y1789 ,	Y1790 ,	Y1791 ,	Y1792 ,	Y1793 ,	Y1794 ,	Y1795 ,	Y1796 ,	Y1797 ,	Y1798 ,	Y1799 ,	Y1800 ,	Y1801 ,	Y1802 ,	Y1803 ,	Y1804 ,	Y1805 ,	Y1806 ,	Y1807 ,	Y1808 ,	Y1809 ,	Y1810 ,	Y1811 ,	Y1812 ,	Y1813 ,	Y1814 ,	Y1815 ,	Y1816 ,	Y1817 ,	Y1818 ,	Y1819 ,	Y1820 ,	Y1821 ,	Y1822 ,	Y1823 ,	Y1824 ,	Y1825 ,	Y1826 ,	Y1827 ,	Y1828 ,	Y1829 ,	Y1830 ,	Y1831 ,	Y1832 ,	Y1833 ,	Y1834 ,	Y1835 ,	Y1836 ,	Y1837 ,	Y1838 ,	Y1839 ,	Y1840 ,	Y1841 ,	Y1842 ,	Y1843 ,	Y1844 ,	Y1845 ,	Y1846 ,	Y1847 ,	Y1848 ,	Y1849 ,	Y1850 ,	Y1851 ,	Y1852 ,	Y1853 ,	Y1854 ,	Y1855 ,	Y1856 ,	Y1857 ,	Y1858 ,	Y1859 ,	Y1860 ,	Y1861 ,	Y1862 ,	Y1863 ,	Y1864 ,	Y1865 ,	Y1866 ,	Y1867 ,	Y1868 ,	Y1869 ,	Y1870 ,	Y1871 ,	Y1872 ,	Y1873 ,	Y1874 ,	Y1875 ,	Y1876 ,	Y1877 ,	Y1878 ,	Y1879 ,	Y1880 ,	Y1881 ,	Y1882 ,	Y1883 ,	Y1884 ,	Y1885 ,	Y1886 ,	Y1887 ,	Y1888 ,	Y1889 ,	Y1890 ,	Y1891 ,	Y1892 ,	Y1893 ,	Y1894 ,	Y1895 ,	Y1896 ,	Y1897 ,	Y1898 ,	Y1899 , Y1900, Y1901 , Y1902 , Y1903 , Y1904 , Y1905 , Y1906 , Y1907 , Y1908 , Y1909 , Y1910 , Y1911 , Y1912 , Y1913 , Y1914 , Y1915 , Y1916 , Y1917 , Y1918 , Y1919 , Y1920 , Y1921 , Y1922 , Y1923 , Y1924 , Y1925 , Y1926 , Y1927 , Y1928 , Y1929 , Y1930 , Y1931 , Y1932 , Y1933 , Y1934 , Y1935 , Y1936 , Y1937 , Y1938 , Y1939 , Y1940 , Y1941 , Y1942 , Y1943 , Y1944 , Y1945 , Y1946 , Y1947 , Y1948 , Y1949 , Y1950 , Y1951 , Y1952 , Y1953 , Y1954 , Y1955 , Y1956 , Y1957 , Y1958 , Y1959 , Y1960 , Y1961 , Y1962 , Y1963 , Y1964 , Y1965 , Y1966 , Y1967 , Y1968 , Y1969 , Y1970 , Y1971 , Y1972 , Y1973 , Y1974 , Y1975 , Y1976 , Y1977, Y1978 , Y1979 , Y1980 , Y1981 , Y1982 , Y1983 , Y1984 , Y1985 , Y1986 , Y1987 , Y1988 , Y1989 , Y1990 , Y1991 , Y1992 , Y1993 , Y1994 , Y1995 , Y1996 , Y1997 , Y1998 , Y1999 , Y2000 , Y2001 , Y2002 , Y2003 , Y2004 , Y2005 , Y2006 , Y2007 , Y2008 , Y2009 , Y2010 , Y2011 , Y2012 , Y2013 , Y2014 , Y2015 , Y2016, YSUM , YSUM_AKT, YSUM_UNCH';

-- PIM futás végén összeadandó táblák
v_pim_sum VARCHAR2(10000) := '(NVL(Y1780, 0) +	NVL(Y1781, 0) +	NVL(Y1782, 0) +	NVL(Y1783, 0) +	NVL(Y1784, 0) +	NVL(Y1785, 0) +	NVL(Y1786, 0) +	NVL(Y1787, 0) +	NVL(Y1788, 0) +	NVL(Y1789, 0) +	NVL(Y1790, 0) +	NVL(Y1791, 0) +	NVL(Y1792, 0) +	NVL(Y1793, 0) +	NVL(Y1794, 0) +	NVL(Y1795, 0) +	NVL(Y1796, 0) +	NVL(Y1797, 0) +	NVL(Y1798, 0) +	NVL(Y1799, 0) +	NVL(Y1800, 0) +	NVL(Y1801, 0) +	NVL(Y1802, 0) +	NVL(Y1803, 0) +	NVL(Y1804, 0) +	NVL(Y1805, 0) +	NVL(Y1806, 0) +	NVL(Y1807, 0) +	NVL(Y1808, 0) +	NVL(Y1809, 0) +	NVL(Y1810, 0) +	NVL(Y1811, 0) +	NVL(Y1812, 0) +	NVL(Y1813, 0) +	NVL(Y1814, 0) +	NVL(Y1815, 0) +	NVL(Y1816, 0) +	NVL(Y1817, 0) +	NVL(Y1818, 0) +	NVL(Y1819, 0) +	NVL(Y1820, 0) +	NVL(Y1821, 0) +	NVL(Y1822, 0) +	NVL(Y1823, 0) +	NVL(Y1824, 0) +	NVL(Y1825, 0) +	NVL(Y1826, 0) +	NVL(Y1827, 0) +	NVL(Y1828, 0) +	NVL(Y1829, 0) +	NVL(Y1830, 0) +	NVL(Y1831, 0) +	NVL(Y1832, 0) +	NVL(Y1833, 0) +	NVL(Y1834, 0) +	NVL(Y1835, 0) +	NVL(Y1836, 0) +	NVL(Y1837, 0) +	NVL(Y1838, 0) +	NVL(Y1839, 0) +	NVL(Y1840, 0) +	NVL(Y1841, 0) +	NVL(Y1842, 0) +	NVL(Y1843, 0) +	NVL(Y1844, 0) +	NVL(Y1845, 0) +	NVL(Y1846, 0) +	NVL(Y1847, 0) +	NVL(Y1848, 0) +	NVL(Y1849, 0) +	NVL(Y1850, 0) +	NVL(Y1851, 0) +	NVL(Y1852, 0) +	NVL(Y1853, 0) +	NVL(Y1854, 0) +	NVL(Y1855, 0) +	NVL(Y1856, 0) +	NVL(Y1857, 0) +	NVL(Y1858, 0) +	NVL(Y1859, 0) +	NVL(Y1860, 0) +	NVL(Y1861, 0) +	NVL(Y1862, 0) +	NVL(Y1863, 0) +	NVL(Y1864, 0) +	NVL(Y1865, 0) +	NVL(Y1866, 0) +	NVL(Y1867, 0) +	NVL(Y1868, 0) +	NVL(Y1869, 0) +	NVL(Y1870, 0) +	NVL(Y1871, 0) +	NVL(Y1872, 0) +	NVL(Y1873, 0) +	NVL(Y1874, 0) +	NVL(Y1875, 0) +	NVL(Y1876, 0) +	NVL(Y1877, 0) +	NVL(Y1878, 0) +	NVL(Y1879, 0) +	NVL(Y1880, 0) +	NVL(Y1881, 0) +	NVL(Y1882, 0) +	NVL(Y1883, 0) +	NVL(Y1884, 0) +	NVL(Y1885, 0) +	NVL(Y1886, 0) +	NVL(Y1887, 0) +	NVL(Y1888, 0) +	NVL(Y1889, 0) +	NVL(Y1890, 0) +	NVL(Y1891, 0) +	NVL(Y1892, 0) +	NVL(Y1893, 0) +	NVL(Y1894, 0) +	NVL(Y1895, 0) +	NVL(Y1896, 0) +	NVL(Y1897, 0) +	NVL(Y1898, 0) +	NVL(Y1899, 0) + NVL(Y1900, 0) + NVL(Y1901, 0) + NVL(Y1902, 0) + NVL(Y1903, 0) + NVL(Y1904, 0) + NVL(Y1905, 0) + NVL(Y1906, 0) + NVL(Y1907, 0) + NVL(Y1908, 0) +  NVL(Y1909, 0) +	NVL(Y1910, 0) +	NVL(Y1911, 0) +	NVL(Y1912, 0) +	NVL(Y1913, 0) +	NVL(Y1914, 0) +	NVL(Y1915, 0) +	NVL(Y1916, 0) +	NVL(Y1917, 0) +	NVL(Y1918, 0) +	NVL(Y1919, 0) +	NVL(Y1920, 0) +	NVL(Y1921, 0) +	NVL(Y1922, 0) +	NVL(Y1923, 0) +	NVL(Y1924, 0) +	NVL(Y1925, 0) +	NVL(Y1926, 0) +	NVL(Y1927, 0) +	NVL(Y1928, 0) +	NVL(Y1929, 0) +	NVL(Y1930, 0) +	NVL(Y1931, 0) +	NVL(Y1932, 0) +	NVL(Y1933, 0) +	NVL(Y1934, 0) +	NVL(Y1935, 0) +	NVL(Y1936, 0) +	NVL(Y1937, 0) +	NVL(Y1938, 0) +	NVL(Y1939, 0) +	NVL(Y1940, 0) +	NVL(Y1941, 0) +	NVL(Y1942, 0) +	NVL(Y1943, 0) +	NVL(Y1944, 0) +	NVL(Y1945, 0) +	NVL(Y1946, 0) +	NVL(Y1947, 0) +	NVL(Y1948, 0) +	NVL(Y1949, 0) +	NVL(Y1950, 0) +	NVL(Y1951, 0) +	NVL(Y1952, 0) +	NVL(Y1953, 0) +	NVL(Y1954, 0) +	NVL(Y1955, 0) +	NVL(Y1956, 0) +	NVL(Y1957, 0) +	NVL(Y1958, 0) +	NVL(Y1959, 0) +	NVL(Y1960, 0) +	NVL(Y1961, 0) +	NVL(Y1962, 0) +	NVL(Y1963, 0) +	NVL(Y1964, 0) +	NVL(Y1965, 0) +	NVL(Y1966, 0) +	NVL(Y1967, 0) +	NVL(Y1968, 0) +	NVL(Y1969, 0) +	NVL(Y1970, 0) +	NVL(Y1971, 0) +	NVL(Y1972, 0) +	NVL(Y1973, 0) +	NVL(Y1974, 0) +	NVL(Y1975, 0) +	NVL(Y1976, 0) +	NVL(Y1977, 0) +	NVL(Y1978, 0) +	NVL(Y1979, 0) +	NVL(Y1980, 0) +	NVL(Y1981, 0) +	NVL(Y1982, 0) +	NVL(Y1983, 0) +	NVL(Y1984, 0) +	NVL(Y1985, 0) +	NVL(Y1986, 0) +	NVL(Y1987, 0) +	NVL(Y1988, 0) +	NVL(Y1989, 0) +	NVL(Y1990, 0) +	NVL(Y1991, 0) +	NVL(Y1992, 0) +	NVL(Y1993, 0) +	NVL(Y1994, 0) +	NVL(Y1995, 0) +	NVL(Y1996, 0) +	NVL(Y1997, 0) +	NVL(Y1998, 0) +	NVL(Y1999, 0) +	NVL(Y2000, 0) +	NVL(Y2001, 0) +	NVL(Y2002, 0) +	NVL(Y2003, 0) +	NVL(Y2004, 0) +	NVL(Y2005, 0) +	NVL(Y2006, 0) +	NVL(Y2007, 0) +	NVL(Y2008, 0) +	NVL(Y2009, 0) +	NVL(Y2010, 0) +	NVL(Y2011, 0) +	NVL(Y2012, 0) +	NVL(Y2013, 0) +	NVL(Y2014, 0) +	NVL(Y2015, 0) + NVL(Y2016, 0) + NVL(Y2017, 0))';


-- PIM futtatás

PROCEDURE create_pim(AKT_EV VARCHAR2, SZEKT VARCHAR2, ALSZEKT VARCHAR2, ESZKOZ VARCHAR2, v_inv2_table VARCHAR2, v_lifetime_table VARCHAR2, v_arindex_1999 VARCHAR2, v_szektor VARCHAR2, v_eszkozcsp VARCHAR2, v_alszektor VARCHAR2, gfcf_year VARCHAR2) AS

procName VARCHAR2(30);
act_year VARCHAR2(30); 
act_minus VARCHAR2(30); 
sql_statement VARCHAR2(500);
v NUMBER;
v2 NUMBER;

type t_collection IS TABLE OF NUMBER(30) INDEX BY BINARY_INTEGER;
l_cell t_collection;
l_idx NUMBER;

--TYPE t_agazat_type IS TABLE OF C_IMP_INV2_T08_S15%ROWTYPE; 
--v_agazat_type t_agazat_type; 


BEGIN

dbms_output.put_line('START: ' || systimestamp);

evszam := '1780';

IF v_alszektor = 'S1' THEN

	v_out_alszektor(1) := 'S11';
	v_out_alszektor(2) := 'S12';
	v_out_alszektor(3) := 'S1311';
	v_out_alszektor(4) := 'S1311a';
	v_out_alszektor(5) := 'S1313';
	v_out_alszektor(6) := 'S1313a';
	v_out_alszektor(7) := 'S1314';
	v_out_alszektor(8) := 'S14';
	v_out_alszektor(9) := 'S15';
	v_out_szektor(1) := 'S11';
	v_out_szektor(2) := 'S12';
	v_out_szektor(3) := 'S13';
	v_out_szektor(4) := 'S13';
	v_out_szektor(5) := 'S13';
	v_out_szektor(6) := 'S13';
	v_out_szektor(7) := 'S13';
	v_out_szektor(8) := 'S14';
	v_out_szektor(9) := 'S15';

ELSIF v_alszektor = 'S13' THEN

	v_out_alszektor(1) := 'S1311';
	v_out_alszektor(2) := 'S1311a';
	v_out_alszektor(3) := 'S1313';
	v_out_alszektor(4) := 'S1313a';
	v_out_alszektor(5) := 'S1314';
	v_out_szektor(1) := 'S13';
	v_out_szektor(2) := 'S13';
	v_out_szektor(3) := 'S13';
	v_out_szektor(4) := 'S13';
	v_out_szektor(5) := 'S13';

ELSE 

	v_out_alszektor(1) := ''|| v_alszektor ||'';
	v_out_szektor(1) := ''|| v_szektor ||'';

END IF;


FOR x IN v_out_alszektor.FIRST..v_out_alszektor.LAST LOOP

IF v_eszkozcsp = 'CLASSIC' THEN 

	IF ''|| v_out_alszektor(x) ||'' = 'S15' THEN

		v_out_eszkozcsp(1) := 'AN112';
		v_out_eszkozcsp(2) := 'AN1131';
		v_out_eszkozcsp(3) := 'AN1139t';
		v_out_name(1) := 'EPULET';
		v_out_name(2) := 'JARMU';
		v_out_name(3) := 'TARTOSGEP';			

	ELSIF ''|| v_out_alszektor(x) ||'' = 'S14' THEN

		v_out_eszkozcsp(1) := 'AN112';
		v_out_eszkozcsp(2) := 'AN1131';
		v_out_eszkozcsp(3) := 'AN1139t';
		v_out_eszkozcsp(4) := 'AN1139g';
		v_out_name(1) := 'EPULET';
		v_out_name(2) := 'JARMU';
		v_out_name(3) := 'TARTOSGEP';	
		v_out_name(4) := 'GYORSGEP';

	ELSE

		v_out_eszkozcsp(1) := 'AN112';
		v_out_eszkozcsp(2) := 'AN1131';
		v_out_eszkozcsp(3) := 'AN1139t';
		v_out_eszkozcsp(4) := 'AN1139g';
		v_out_eszkozcsp(5) := 'AN1173s';
		v_out_name(1) := 'EPULET';
		v_out_name(2) := 'JARMU';
		v_out_name(3) := 'TARTOSGEP';	
		v_out_name(4) := 'GYORSGEP';
		v_out_name(5) := 'SZOFTVER';			

	END IF;


ELSIF v_eszkozcsp = 'EGYEB' THEN 

	IF ''|| v_out_alszektor(x) ||'' = 'S1311' THEN

		v_out_eszkozcsp(1) := 'AN114';
		v_out_eszkozcsp(2) := 'AN1123';
		v_out_eszkozcsp(3) := 'AN1173o';
		v_out_eszkozcsp(4) := 'AN1171';
		v_out_name(1) := 'FEGYVER';
		v_out_name(2) := 'FOLDJAVITAS';
		v_out_name(3) := 'OWNSOFT';	
		v_out_name(4) := 'K_F';	


	ELSIF ''|| v_out_alszektor(x) ||'' = 'S1313' THEN

		v_out_eszkozcsp(1) := 'AN1123';
		v_out_name(1) := 'FOLDJAVITAS';

	ELSIF ''|| v_out_alszektor(x) ||'' = 'S1311a' THEN

		v_out_eszkozcsp(1) := 'AN1174';
		v_out_eszkozcsp(2) := 'AN1171';
		v_out_name(1) := 'ORIGINALS';
		v_out_name(2) := 'K_F';			

	ELSIF ''|| v_out_alszektor(x) ||'' = 'S1313a' THEN

		v_out_eszkozcsp(1) := 'AN1174';
		v_out_name(1) := 'ORIGINALS';

	ELSIF ''|| v_out_alszektor(x) ||'' = 'S11' THEN

		v_out_eszkozcsp(1) := 'AN1123';
		v_out_eszkozcsp(2) := 'AN1173o';
		v_out_eszkozcsp(3) := 'AN1174';
		v_out_eszkozcsp(4) := 'AN1171';
		v_out_eszkozcsp(5) := 'AN1139k';
		v_out_eszkozcsp(6) := 'AN1131w';
		v_out_eszkozcsp(7) := 'AN1174t';
		v_out_eszkozcsp(8) := 'AN1174a';
		v_out_eszkozcsp(9) := 'AN112n';
		v_out_name(1) := 'FOLDJAVITAS';
		v_out_name(2) := 'OWNSOFT';
		v_out_name(3) := 'ORIGINALS';	
		v_out_name(4) := 'K_F';	
		v_out_name(5) := 'KISERTEKU';
		v_out_name(6) := 'WIZZ';
		v_out_name(7) := 'TCF';
		v_out_name(8) := 'EGYEB_ORIG';
		v_out_name(9) := 'NOE6';

	ELSIF ''|| v_out_alszektor(x) ||'' = 'S12' THEN

		v_out_eszkozcsp(1) := 'AN1173o';
		v_out_name(1) := 'OWNSOFT';


	ELSIF ''|| v_out_alszektor(x) ||'' = 'S14' THEN

		v_out_eszkozcsp(1) := 'AN1123';
		v_out_eszkozcsp(2) := 'AN1173o';
		v_out_eszkozcsp(3) := 'AN1174';
		v_out_name(1) := 'FOLDJAVITAS';
		v_out_name(2) := 'OWNSOFT';
		v_out_name(3) := 'ORIGINALS';	

	ELSIF ''|| v_out_alszektor(x) ||'' = 'S15' THEN

		v_out_eszkozcsp(1) := 'AN1171';
		v_out_name(1) := 'K_F';	

	END IF;

	-- WHEN 'AN114' THEN eszkoz := 'FEGYVER';  - S1311
	-- WHEN 'AN1123' THEN eszkoz := 'FOLDJAVITAS'; - S11, S1311, S1313, S14
	-- WHEN 'AN1173o' THEN eszkoz := 'OWNSOFT'; - S11, S12, S1311, S14
	-- WHEN 'AN1174' THEN eszkoz := 'ORIGINALS'; - S11, S1311, S1313, S14
	-- WHEN 'AN1171' THEN eszkoz := 'K_F'; - S11, S1311, S1311a, S15	
	-- WHEN 'AN1139k' THEN eszkoz := 'KISERT'; -- S11
	-- WHEN 'AN1131w' THEN eszkoz := 'WIZZ'; -- S11
	-- WHEN 'AN1174t' THEN eszkoz := 'TCF'; -- S11
	-- WHEN 'AN1174a' THEN eszkoz := 'egyeb_orig'; -- S11
	-- WHEN 'AN112n' THEN eszkoz := 'NOE6'; -- S11	

ELSE

v_out_eszkozcsp(1) := ''|| v_eszkozcsp ||'';
v_out_name(1) := ''|| eszkoz ||'';

END IF;



FOR b IN v_out_eszkozcsp.FIRST..v_out_eszkozcsp.LAST LOOP

-- SELECT COUNT(*) INTO v FROM user_tab_cols WHERE table_name = UPPER(''|| v_out_name(b) ||'_1995');

-- IF v > 0 THEN

-- sql_statement := 'SELECT COUNT(*) FROM '|| v_out_name(b) ||'_1995 WHERE ALSZEKTOR = '''|| v_out_alszektor(x) ||' '' ';

-- EXECUTE IMMEDIATE sql_statement INTO v2;

-- IF v2 > 0 THEN


procName := 'Start_PIM';
act_year := ''|| AKT_EV ||'' + 1; -- a CFC számolásnál szükséges, amikor visszaszámolunk aktuális árra (ellentétben a NET és GRS számolással, itt nem az aktuális évre, hanem aktuális + 1 évre számolunk)
act_minus := ''|| AKT_EV ||'' - 1; -- folyó ár kiszámításánál szükséges

	-- associative array-ba áttesszük a INV2_xx tábla AGAZAT sorait, ahonnan majd az ágazatok listáját fogjuk felhasználni
	sql_statement := 'SELECT AGAZAT FROM PKD.'|| v_inv2_table ||' WHERE ALSZEKTOR = '''|| v_out_alszektor(x) ||''' AND ESZKOZCSP = '''|| v_out_eszkozcsp(b) ||''' '; 

	--EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_agazat_type;
	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO V_AGAZAT_IMP;

	-- log
	INSERT INTO logging (created_on, info, proc_name, message, backtrace)
	VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', ''|| procName ||'', 'STARTING '''|| v_out_eszkozcsp(b) ||''' ', '');

	--> 1.lépés: PIM futtatása

		-- létrehozzuk a sorokat ágazatok szerint, feltöltjük a szükséges mezőértékekkel

	FOR a IN 1..v_pim.COUNT LOOP 

	 -- log
	INSERT INTO logging (created_on, info, proc_name, message, backtrace)
	VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', ''|| procName ||'', 'Create '|| v_out_szektor(x) ||'_'|| v_out_alszektor(x) ||'_'|| v_out_name(b) ||'_'|| v_pim(a) ||'_'|| AKT_EV ||'', '');

		EXECUTE IMMEDIATE'
		CREATE TABLE '|| v_out_schema ||'.'|| v_out_szektor(x) ||'_'|| v_out_alszektor(x) ||'_'|| v_out_name(b) ||'_'|| v_pim(a) ||'_'|| AKT_EV ||' 
		'|| v_pim_create ||'
		'
		;



-- log
INSERT INTO logging (created_on, info, proc_name, message, backtrace)
VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', ''|| procName ||'', 'Calculate PIM', '');

		FOR l IN 1..V_AGAZAT_IMP.COUNT LOOP

		-- INV2 táblából átvesszük az adatokat

			EXECUTE IMMEDIATE'
				INSERT INTO '|| v_out_schema ||'.'|| v_out_szektor(x) ||'_'|| v_out_alszektor(x) ||'_'|| v_out_name(b) ||'_'|| v_pim(a) ||'_'|| AKT_EV ||'
				(OUTPUT, SZEKTOR, ALSZEKTOR, ESZKOZCSP, AGAZAT, EGYEB)
				SELECT '''|| v_pim(a) ||''' as OUTPUT, SZEKTOR, ALSZEKTOR, ESZKOZCSP, AGAZAT, EGYEB
				FROM '|| v_out_schema ||'.'|| v_inv2_table ||'
				WHERE ESZKOZCSP = '''|| v_out_eszkozcsp(b) ||''' 
				AND ALSZEKTOR = '''|| v_out_alszektor(x) ||''' AND AGAZAT = '|| V_AGAZAT_IMP(l) ||'
				'
				;		

-- évváltás esetén módosítani kell az évszámot
			--FOR m IN 1780..2016 LOOP 
			LOOP
				EXIT WHEN evszam > gfcf_year+1;

				--l_cell(m) := m;
				l_cell(evszam) := evszam;
				evszam := evszam + 1;

			END LOOP;

			l_idx := l_cell.FIRST;

			WHILE l_idx IS NOT NULL LOOP

				EXECUTE IMMEDIATE'
				UPDATE '|| v_out_schema ||'.'|| v_out_szektor(x) ||'_'|| v_out_alszektor(x) ||'_'|| v_out_name(b) ||'_'|| v_pim(a) ||'_'|| AKT_EV ||'
				SET Y'|| l_cell(l_idx) ||' = (SELECT (Y'|| l_cell(l_idx) ||' * (SELECT ERTEK FROM PKD.'|| V_PIM_INPUT(a) ||'
				WHERE EV = ('|| AKT_EV ||' - '|| l_cell(l_idx) ||') 
				AND LIFETIME = (SELECT Y'|| l_cell(l_idx) ||' FROM '|| v_out_schema ||'.'|| v_lifetime_table ||'
				WHERE AGAZAT = '|| V_AGAZAT_IMP(l) ||' AND ALSZEKTOR = '''|| v_out_alszektor(x) ||''' 
				AND ESZKOZCSP = '''|| v_out_eszkozcsp(b) ||''' )))
				FROM '|| v_out_schema ||'.'|| v_inv2_table ||'
				WHERE AGAZAT = '|| V_AGAZAT_IMP(l) ||' AND ALSZEKTOR = '''|| v_out_alszektor(x) ||''' 
				AND ESZKOZCSP = '''|| v_out_eszkozcsp(b) ||''')
				WHERE ALSZEKTOR = '''|| v_out_alszektor(x) ||''' AND ESZKOZCSP = '''|| v_out_eszkozcsp(b) ||''' AND AGAZAT = '|| V_AGAZAT_IMP(l) ||'
				'
				;

			l_idx := l_cell.NEXT(l_idx);

			END LOOP;	

		END LOOP;


		-- 2.lépés: összeadjuk az eredményeket és sum mezőbe elmentjük

-- log
INSERT INTO logging (created_on, info, proc_name, message, backtrace)
VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', ''|| procName ||'', 'Calculate SUM', '');

		FOR n IN 1..V_AGAZAT_IMP.COUNT LOOP  

			EXECUTE IMMEDIATE'
			UPDATE '|| v_out_schema ||'.'|| v_out_szektor(x) ||'_'|| v_out_alszektor(x) ||'_'|| v_out_name(b) ||'_'|| v_pim(a) ||'_'|| AKT_EV ||'
			SET YSUM = 
			(SELECT '|| v_pim_sum ||' FROM '|| v_out_schema ||'.'|| v_out_szektor(x) ||'_'|| v_out_alszektor(x) ||'_'|| v_out_name(b) ||'_'|| v_pim(a) ||'_'|| AKT_EV ||'
			WHERE AGAZAT = '|| V_AGAZAT_IMP(n) ||')
			WHERE AGAZAT = '|| V_AGAZAT_IMP(n) ||'
			'
			;


		END LOOP;


		--3. lépés: létrehozunk egy átmeneti táblát, ahol 1 évvel eltoljuk a CFC értékeket


			CASE WHEN ''|| v_pim(a) ||'' = 'net' OR ''|| v_pim(a) ||'' =  'grs' THEN  

				DBMS_OUTPUT.put_line('');

			 WHEN ''|| v_pim(a) ||'' = 'cfc' THEN

				-- log
				INSERT INTO logging (created_on, info, proc_name, message, backtrace)
				VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', ''|| procName ||'', 'Copy CFC data to 1 year', '');		

				EXECUTE IMMEDIATE'
					CREATE TABLE '|| v_out_schema ||'.'|| v_pim(a) ||'_'|| AKT_EV ||'_2
					'|| v_pim_create ||'
					'
					;				


				EXECUTE IMMEDIATE'
					INSERT INTO '|| v_out_schema ||'.'|| v_pim(a) ||'_'|| AKT_EV ||'_2
					('|| v_pim_create_out_cfc ||' FROM '|| v_out_schema ||'.'|| v_out_szektor(x) ||'_'|| v_out_alszektor(x) ||'_'|| v_out_name(b) ||'_'|| v_pim(a) ||'_'|| AKT_EV ||'
					'
					;					

				PKD.drop_table(''|| v_out_szektor(x) ||'_'|| v_out_alszektor(x) ||'_'|| v_out_name(b) ||'_'|| v_pim(a) ||'_'|| AKT_EV ||'');


				EXECUTE IMMEDIATE'
					ALTER TABLE '|| v_out_schema ||'.'|| v_pim(a) ||'_'|| AKT_EV ||'_2
					RENAME TO '|| v_out_szektor(x) ||'_'|| v_out_alszektor(x) ||'_'|| v_out_name(b) ||'_'|| v_pim(a) ||'_'|| AKT_EV ||'
					'
					;				


			END CASE;


		-- 4.lépés: aktuális évre számolunk árindexet (1999-ről vissza) -- CFC esetében ha 2016-ra futtatunk, akkor 2016-os árindex-el számol, ugyanekkor NET és GRS esetében 2015-ös adatok kiszámolásakor 2015-ös árindex adatokkal számol

		-- log
INSERT INTO logging (created_on, info, proc_name, message, backtrace)
VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', ''|| procName ||'', 'Calculate actual price', '');		

	sum_1999 := 'a.YSUM * b.Y'|| AKT_EV ||'_1999'; -- folyó ár kiszámítása
	sum_unch := 'a.YSUM * b.Y'|| act_minus ||'_1999'; -- változatlan ár kiszámítása

		FOR o IN 1..V_AGAZAT_IMP.COUNT LOOP 

				-- folyó ár kiszámítása
				EXECUTE IMMEDIATE'
				UPDATE '|| v_out_schema ||'.'|| v_out_szektor(x) ||'_'|| v_out_alszektor(x) ||'_'|| v_out_name(b) ||'_'|| v_pim(a) ||'_'|| AKT_EV ||'
				SET YSUM_AKT = (SELECT '|| sum_1999 ||' as YSUM_AKT
				FROM '|| v_out_schema ||'.'|| v_out_szektor(x) ||'_'|| v_out_alszektor(x) ||'_'|| v_out_name(b) ||'_'|| v_pim(a) ||'_'|| AKT_EV ||' a
				INNER JOIN '|| v_out_schema ||'.'|| v_arindex_1999 ||' b
				ON a.AGAZAT = b. AGAZAT
				WHERE a.AGAZAT = '|| V_AGAZAT_IMP(o) ||'
				AND b.ALSZEKTOR = '''|| v_out_alszektor(x) ||''' AND b.ESZKOZCSP = '''|| v_out_eszkozcsp(b) ||''')
				WHERE AGAZAT = '|| V_AGAZAT_IMP(o) ||'
				'
				;

		END LOOP;

		IF act_minus > '1994' THEN 

		FOR o IN 1..V_AGAZAT_IMP.COUNT LOOP 		

				-- változatlan ár kiszámítása
				EXECUTE IMMEDIATE'
				UPDATE '|| v_out_schema ||'.'|| v_out_szektor(x) ||'_'|| v_out_alszektor(x) ||'_'|| v_out_name(b) ||'_'|| v_pim(a) ||'_'|| AKT_EV ||'
				SET YSUM_UNCH = (SELECT '|| sum_unch ||' as YSUM_UNCH
				FROM '|| v_out_schema ||'.'|| v_out_szektor(x) ||'_'|| v_out_alszektor(x) ||'_'|| v_out_name(b) ||'_'|| v_pim(a) ||'_'|| AKT_EV ||' a
				INNER JOIN '|| v_out_schema ||'.'|| v_arindex_1999 ||' b
				ON a.AGAZAT = b. AGAZAT
				WHERE a.AGAZAT = '|| V_AGAZAT_IMP(o) ||'
				AND b.ALSZEKTOR = '''|| v_out_alszektor(x) ||''' AND b.ESZKOZCSP = '''|| v_out_eszkozcsp(b) ||''')
				WHERE AGAZAT = '|| V_AGAZAT_IMP(o) ||'
				'
				;

		END LOOP;

		END IF;


		--5. lépés készítünk egy végleges SUM értéket az ágazatok összesenről

		-- log
INSERT INTO logging (created_on, info, proc_name, message, backtrace)
VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', ''|| procName ||'', 'Calculate price SUM', '');

	EXECUTE IMMEDIATE'
		INSERT INTO '|| v_out_schema ||'.'|| v_out_szektor(x) ||'_'|| v_out_alszektor(x) ||'_'|| v_out_name(b) ||'_'|| v_pim(a) ||'_'|| AKT_EV ||'
		(output, szektor, ALSZEKTOR, eszkozcsp, agazat, YSUM, YSUM_AKT, YSUM_UNCH)
		SELECT '''|| v_pim(a) ||''' , '''|| v_out_szektor(x) ||''', '''|| v_out_alszektor(x) ||''', '''|| v_out_eszkozcsp(b) ||''', ''SUM'', sum(YSUM), sum(YSUM_AKT), sum(YSUM_UNCH)
		FROM '|| v_out_schema ||'.'|| v_out_szektor(x) ||'_'|| v_out_alszektor(x) ||'_'|| v_out_name(b) ||'_'|| v_pim(a) ||'_'|| AKT_EV ||'
		WHERE ALSZEKTOR = '''|| v_out_alszektor(x) ||''' AND ESZKOZCSP = '''|| v_out_eszkozcsp(b) ||'''
		GROUP BY szektor, eszkozcsp

		'
		;

	END LOOP;


	--> 6.lépés: végtábla létrehozása

		-- log
INSERT INTO logging (created_on, info, proc_name, message, backtrace)
VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', ''|| procName ||'', 'Create output table', '');

	EXECUTE IMMEDIATE'
		CREATE TABLE '|| v_out_schema ||'.'|| v_out_szektor(x) ||'_'|| v_out_alszektor(x) ||'_'|| v_out_name(b) ||'_'|| AKT_EV ||'
		'|| v_pim_create ||'
		'
		;

	EXECUTE IMMEDIATE'
		INSERT INTO '|| v_out_schema ||'.'|| v_out_szektor(x) ||'_'|| v_out_alszektor(x) ||'_'|| v_out_name(b) ||'_'|| AKT_EV ||'
		('|| v_pim_create_out ||' FROM '|| v_out_schema ||'.'|| v_out_szektor(x) ||'_'|| v_out_alszektor(x) ||'_'|| v_out_name(b) ||'_CFC_'|| AKT_EV ||'
		'
		;


	EXECUTE IMMEDIATE'
		INSERT INTO '|| v_out_schema ||'.'|| v_out_szektor(x) ||'_'|| v_out_alszektor(x) ||'_'|| v_out_name(b) ||'_'|| AKT_EV ||'
		('|| v_pim_create_out ||' FROM '|| v_out_schema ||'.'|| v_out_szektor(x) ||'_'|| v_out_alszektor(x) ||'_'|| v_out_name(b) ||'_NET_'|| AKT_EV ||'
		'
		;


	EXECUTE IMMEDIATE'
		INSERT INTO '|| v_out_schema ||'.'|| v_out_szektor(x) ||'_'|| v_out_alszektor(x) ||'_'|| v_out_name(b) ||'_'|| AKT_EV ||'
		('|| v_pim_create_out ||'	FROM '|| v_out_schema ||'.'|| v_out_szektor(x) ||'_'|| v_out_alszektor(x) ||'_'|| v_out_name(b) ||'_GRS_'|| AKT_EV ||'
		'
		;

	COMMIT;


		-- log
INSERT INTO logging (created_on, info, proc_name, message, backtrace)
VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', ''|| procName ||'', 'Delete temp tables', '');

PKD.drop_table(''|| v_out_szektor(x) ||'_'|| v_out_alszektor(x) ||'_'|| v_out_name(b) ||'_CFC_'|| AKT_EV ||'');
PKD.drop_table(''|| v_out_szektor(x) ||'_'|| v_out_alszektor(x) ||'_'|| v_out_name(b) ||'_GRS_'|| AKT_EV ||'');
PKD.drop_table(''|| v_out_szektor(x) ||'_'|| v_out_alszektor(x) ||'_'|| v_out_name(b) ||'_NET_'|| AKT_EV ||'');

--END IF;

--END IF;


END LOOP;

END LOOP;

-- log
INSERT INTO logging (created_on, info, proc_name, message, backtrace)
VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', ''|| procName ||'', 'END', '');

-- error case	
-- EXCEPTION WHEN OTHERS THEN
-- record_error(procName);
-- RAISE;

dbms_output.put_line('END: ' || systimestamp);

END create_pim;




procedure sector_unite(AKT_EV VARCHAR2, ESZKOZ VARCHAR2, v_szektor VARCHAR2, v_alszektor VARCHAR2, v_eszkozcsp VARCHAR2) AS 
v NUMERIC;

BEGIN

IF v_alszektor = 'S1' THEN

	v_out_alszektor(1) := 'S11';
	v_out_alszektor(2) := 'S12';
	v_out_alszektor(3) := 'S1311';
	v_out_alszektor(4) := 'S1311a';
	v_out_alszektor(5) := 'S1313';
	v_out_alszektor(6) := 'S1313a';
	v_out_alszektor(7) := 'S1314';
	v_out_alszektor(8) := 'S14';
	v_out_alszektor(9) := 'S15';
	v_out_szektor(1) := 'S11';
	v_out_szektor(2) := 'S12';
	v_out_szektor(3) := 'S13';
	v_out_szektor(4) := 'S13';
	v_out_szektor(5) := 'S13';
	v_out_szektor(6) := 'S13';
	v_out_szektor(7) := 'S13';
	v_out_szektor(8) := 'S14';
	v_out_szektor(9) := 'S15';

ELSIF v_alszektor = 'S13' THEN

	v_out_alszektor(1) := 'S1311';
	v_out_alszektor(2) := 'S1311a';
	v_out_alszektor(3) := 'S1313';
	v_out_alszektor(4) := 'S1313a';
	v_out_alszektor(5) := 'S1314';
	v_out_szektor(1) := 'S13';
	v_out_szektor(2) := 'S13';
	v_out_szektor(3) := 'S13';
	v_out_szektor(4) := 'S13';
	v_out_szektor(5) := 'S13';

ELSE 

	v_out_alszektor(1) := ''|| v_alszektor ||'';
	v_out_szektor(1) := ''|| v_szektor ||'';

END IF;


FOR x IN v_out_alszektor.FIRST..v_out_alszektor.LAST LOOP

IF v_eszkozcsp = 'CLASSIC' THEN 

	IF ''|| v_out_alszektor(x) ||'' = 'S15' THEN

		v_out_eszkozcsp(1) := 'AN112';
		v_out_eszkozcsp(2) := 'AN1131';
		v_out_eszkozcsp(3) := 'AN1139t';
		v_out_name(1) := 'EPULET';
		v_out_name(2) := 'JARMU';
		v_out_name(3) := 'TARTOSGEP';			

	ELSE

		v_out_eszkozcsp(1) := 'AN112';
		v_out_eszkozcsp(2) := 'AN1131';
		v_out_eszkozcsp(3) := 'AN1139t';
		v_out_eszkozcsp(4) := 'AN1139g';
		v_out_eszkozcsp(5) := 'AN1173s';
		v_out_name(1) := 'EPULET';
		v_out_name(2) := 'JARMU';
		v_out_name(3) := 'TARTOSGEP';	
		v_out_name(4) := 'GYORSGEP';
		v_out_name(5) := 'SZOFTVER';			

	END IF;


ELSIF v_eszkozcsp = 'EGYEB' THEN 

	IF ''|| v_out_alszektor(x) ||'' = 'S1311' THEN

		v_out_eszkozcsp(1) := 'AN114';
		v_out_eszkozcsp(2) := 'AN1123';
		v_out_eszkozcsp(3) := 'AN1173o';
		v_out_eszkozcsp(4) := 'AN1171';
		v_out_name(1) := 'FEGYVER';
		v_out_name(2) := 'FOLDJAVITAS';
		v_out_name(3) := 'OWNSOFT';	
		v_out_name(4) := 'K_F';	


	ELSIF ''|| v_out_alszektor(x) ||'' = 'S1313' THEN

		v_out_eszkozcsp(1) := 'AN1123';
		v_out_name(1) := 'FOLDJAVITAS';

	ELSIF ''|| v_out_alszektor(x) ||'' = 'S1311a' THEN

		v_out_eszkozcsp(1) := 'AN1174';
		v_out_eszkozcsp(2) := 'AN1171';
		v_out_name(1) := 'ORIGINALS';
		v_out_name(2) := 'K_F';			

	ELSIF ''|| v_out_alszektor(x) ||'' = 'S1313a' THEN

		v_out_eszkozcsp(1) := 'AN1174';
		v_out_name(1) := 'ORIGINALS';

	ELSIF ''|| v_out_alszektor(x) ||'' = 'S11' THEN

		v_out_eszkozcsp(1) := 'AN1123';
		v_out_eszkozcsp(2) := 'AN1173o';
		v_out_eszkozcsp(3) := 'AN1174';
		v_out_eszkozcsp(4) := 'AN1171';
		v_out_eszkozcsp(5) := 'AN1139k';
		v_out_eszkozcsp(6) := 'AN1131w';
		v_out_eszkozcsp(7) := 'AN1174t';
		v_out_eszkozcsp(8) := 'AN1174a';
		v_out_eszkozcsp(9) := 'AN112n';
		v_out_name(1) := 'FOLDJAVITAS';
		v_out_name(2) := 'OWNSOFT';
		v_out_name(3) := 'ORIGINALS';	
		v_out_name(4) := 'K_F';	
		v_out_name(5) := 'KISERTEKU';
		v_out_name(6) := 'WIZZ';
		v_out_name(7) := 'TCF';
		v_out_name(8) := 'EGYEB_ORIG';
		v_out_name(9) := 'NOE6';

	ELSIF ''|| v_out_alszektor(x) ||'' = 'S12' THEN

		v_out_eszkozcsp(1) := 'AN1173o';
		v_out_name(1) := 'OWNSOFT';


	ELSIF ''|| v_out_alszektor(x) ||'' = 'S14' THEN

		v_out_eszkozcsp(1) := 'AN1123';
		v_out_eszkozcsp(2) := 'AN1173o';
		v_out_eszkozcsp(3) := 'AN1174';
		v_out_name(1) := 'FOLDJAVITAS';
		v_out_name(2) := 'OWNSOFT';
		v_out_name(3) := 'ORIGINALS';	

	ELSIF ''|| v_out_alszektor(x) ||'' = 'S15' THEN

		v_out_eszkozcsp(1) := 'AN1171';
		v_out_name(1) := 'K_F';	

	END IF;

	-- WHEN 'AN114' THEN eszkoz := 'FEGYVER';  - S1311
	-- WHEN 'AN1123' THEN eszkoz := 'FOLDJAVITAS'; - S11, S1311, S1313, S14
	-- WHEN 'AN1173o' THEN eszkoz := 'OWNSOFT'; - S11, S12, S1311, S14
	-- WHEN 'AN1174' THEN eszkoz := 'ORIGINALS'; - S11, S1311, S1313, S14
	-- WHEN 'AN1171' THEN eszkoz := 'K_F'; - S11, S1311, S1311a, S15	
	-- WHEN 'AN1139k' THEN eszkoz := 'KISERT'; -- S11
	-- WHEN 'AN1131w' THEN eszkoz := 'WIZZ'; -- S11
	-- WHEN 'AN1174t' THEN eszkoz := 'TCF'; -- S11
	-- WHEN 'AN1174a' THEN eszkoz := 'egyeb_orig'; -- S11
	-- WHEN 'AN112n' THEN eszkoz := 'NOE6'; -- S11	

ELSE

v_out_eszkozcsp(1) := ''|| v_eszkozcsp ||'';
v_out_name(1) := ''|| eszkoz ||'';

END IF;


FOR b IN v_out_eszkozcsp.FIRST..v_out_eszkozcsp.LAST LOOP

		DBMS_OUTPUT.PUT_LINE(''|| v_out_alszektor(x) ||'');
		DBMS_OUTPUT.PUT_LINE(''|| v_out_eszkozcsp(b) ||'');


		SELECT COUNT(*) INTO v FROM all_tables where table_name = UPPER(''|| v_out_szektor(x) ||'_'|| v_out_alszektor(x) ||'_'|| v_out_name(b) ||'_'|| AKT_EV ||'');
		IF v=1 THEN

		SELECT COUNT(*) INTO v FROM all_tables where table_name = UPPER(''|| v_out_name(b) ||'_'|| AKT_EV ||'');

		if v=0 THEN

				EXECUTE IMMEDIATE'
				CREATE TABLE '|| v_out_name(b) ||'_'|| AKT_EV ||'
				("OUTPUT" VARCHAR2(5), "SZEKTOR" VARCHAR2(100 BYTE), "ALSZEKTOR" VARCHAR2(100 BYTE), "ALSZEKTOR2" VARCHAR2(100 BYTE), "ESZKOZCSP" VARCHAR2(100 BYTE), "AGAZAT" VARCHAR2(30 BYTE),"EGYEB" VARCHAR2(30 BYTE), 
				"Y1780" NUMBER,	"Y1781" NUMBER ,	Y1782 NUMBER ,	Y1783 NUMBER,	Y1784 NUMBER,	Y1785 NUMBER,	Y1786 NUMBER,	Y1787 NUMBER,	Y1788 NUMBER,	Y1789 NUMBER,	Y1790 NUMBER,	Y1791 NUMBER,	Y1792 NUMBER,	Y1793 NUMBER,	Y1794 NUMBER,	Y1795 NUMBER,	Y1796 NUMBER,	Y1797 NUMBER,	Y1798 NUMBER,	Y1799 NUMBER,	Y1800 NUMBER,	Y1801 NUMBER,	Y1802 NUMBER,	Y1803 NUMBER,	Y1804 NUMBER,	Y1805 NUMBER,	Y1806 NUMBER,	Y1807 NUMBER,	Y1808 NUMBER,	Y1809 NUMBER,	Y1810 NUMBER,	Y1811 NUMBER,	Y1812 NUMBER,	Y1813 NUMBER,	Y1814 NUMBER,	Y1815 NUMBER,	Y1816 NUMBER,	Y1817 NUMBER,	Y1818 NUMBER,	Y1819 NUMBER,	Y1820 NUMBER,	Y1821 NUMBER,	Y1822 NUMBER,	Y1823 NUMBER,	Y1824 NUMBER,	Y1825 NUMBER,	Y1826 NUMBER,	Y1827 NUMBER,	Y1828 NUMBER,	Y1829 NUMBER,	Y1830 NUMBER,	Y1831 NUMBER,	Y1832 NUMBER,	Y1833 NUMBER,	Y1834 NUMBER,	Y1835 NUMBER,	Y1836 NUMBER,	Y1837 NUMBER,	Y1838 NUMBER,	Y1839 NUMBER,	Y1840 NUMBER,	Y1841 NUMBER,	Y1842 NUMBER,	Y1843 NUMBER,	Y1844 NUMBER,	Y1845 NUMBER,	Y1846 NUMBER,	Y1847 NUMBER,	Y1848 NUMBER,	Y1849 NUMBER,	Y1850 NUMBER,	Y1851 NUMBER,	Y1852 NUMBER,	Y1853 NUMBER,	Y1854 NUMBER,	Y1855 NUMBER,	Y1856 NUMBER,	Y1857 NUMBER,	Y1858 NUMBER,	Y1859 NUMBER,	Y1860 NUMBER,	Y1861 NUMBER,	Y1862 NUMBER,	Y1863 NUMBER,	Y1864 NUMBER,	Y1865 NUMBER,	Y1866 NUMBER,	Y1867 NUMBER,	Y1868 NUMBER,	Y1869 NUMBER,	Y1870 NUMBER,	Y1871 NUMBER,	Y1872 NUMBER,	Y1873 NUMBER,	Y1874 NUMBER,	Y1875 NUMBER,	Y1876 NUMBER,	Y1877 NUMBER,	Y1878 NUMBER,	Y1879 NUMBER,	Y1880 NUMBER,	Y1881 NUMBER,	Y1882 NUMBER,	Y1883 NUMBER,	Y1884 NUMBER,	Y1885 NUMBER,	Y1886 NUMBER,	Y1887 NUMBER,	Y1888 NUMBER,	Y1889 NUMBER,	Y1890 NUMBER,	Y1891 NUMBER,	Y1892 NUMBER,	Y1893 NUMBER,	Y1894 NUMBER,	Y1895 NUMBER,	Y1896 NUMBER,	Y1897 NUMBER,	Y1898 NUMBER,	Y1899 NUMBER,

				"Y1900" NUMBER, "Y1901" NUMBER, "Y1902" NUMBER, "Y1903" NUMBER, "Y1904" NUMBER, "Y1905" NUMBER, "Y1906" NUMBER, "Y1907" NUMBER, "Y1908" NUMBER, "Y1909" NUMBER, "Y1910" NUMBER, "Y1911" NUMBER, "Y1912" NUMBER, "Y1913" NUMBER, "Y1914" NUMBER, "Y1915" NUMBER, "Y1916" NUMBER, "Y1917" NUMBER, "Y1918" NUMBER, "Y1919" NUMBER, "Y1920" NUMBER, "Y1921" NUMBER, "Y1922" NUMBER, "Y1923" NUMBER, "Y1924" NUMBER, "Y1925" NUMBER, "Y1926" NUMBER, "Y1927" NUMBER, "Y1928" NUMBER, "Y1929" NUMBER, "Y1930" NUMBER, "Y1931" NUMBER, "Y1932" NUMBER, "Y1933" NUMBER, "Y1934" NUMBER, "Y1935" NUMBER, "Y1936" NUMBER, "Y1937" NUMBER, "Y1938" NUMBER, "Y1939" NUMBER, "Y1940" NUMBER, "Y1941" NUMBER, "Y1942" NUMBER, "Y1943" NUMBER, "Y1944" NUMBER, "Y1945" NUMBER, "Y1946" NUMBER, "Y1947" NUMBER, "Y1948" NUMBER, "Y1949" NUMBER, "Y1950" NUMBER, "Y1951" NUMBER, "Y1952" NUMBER, "Y1953" NUMBER, "Y1954" NUMBER, "Y1955" NUMBER, "Y1956" NUMBER, "Y1957" NUMBER, "Y1958" NUMBER, "Y1959" NUMBER, "Y1960" NUMBER, "Y1961" NUMBER, "Y1962" NUMBER, "Y1963" NUMBER, "Y1964" NUMBER, "Y1965" NUMBER, "Y1966" NUMBER, "Y1967" NUMBER, "Y1968" NUMBER, "Y1969" NUMBER, "Y1970" NUMBER, "Y1971" NUMBER, "Y1972" NUMBER, "Y1973" NUMBER, "Y1974" NUMBER, "Y1975" NUMBER, "Y1976" NUMBER, "Y1977" NUMBER, "Y1978" NUMBER, "Y1979" NUMBER, "Y1980" NUMBER, "Y1981" NUMBER, "Y1982" NUMBER, "Y1983" NUMBER, "Y1984" NUMBER, "Y1985" NUMBER, "Y1986" NUMBER, "Y1987" NUMBER, "Y1988" NUMBER, "Y1989" NUMBER, "Y1990" NUMBER, "Y1991" NUMBER, "Y1992" NUMBER, "Y1993" NUMBER, "Y1994" NUMBER, "Y1995" NUMBER, "Y1996" NUMBER, "Y1997" NUMBER, "Y1998" NUMBER, "Y1999" NUMBER, "Y2000" NUMBER, "Y2001" NUMBER, "Y2002" NUMBER, "Y2003" NUMBER, "Y2004" NUMBER, "Y2005" NUMBER, "Y2006" NUMBER, "Y2007" NUMBER, "Y2008" NUMBER, "Y2009" NUMBER, "Y2010" NUMBER, "Y2011" NUMBER, "Y2012" NUMBER, "Y2013" NUMBER, "Y2014" NUMBER, "Y2015" NUMBER, "Y2016" NUMBER, "Y2017" NUMBER, "YSUM" NUMBER,  "YSUM_AKT" NUMBER, "YSUM_UNCH" NUMBER)
				'
				;

		END IF;		


		EXECUTE IMMEDIATE'
		DELETE FROM '|| v_out_schema ||'.'|| v_out_name(b) ||'_'|| AKT_EV ||'
		WHERE ALSZEKTOR = '''|| v_out_alszektor(x) ||''' AND ESZKOZCSP = '''|| v_out_eszkozcsp(b) ||'''
		'
		;

		EXECUTE IMMEDIATE'
		INSERT INTO '|| v_out_schema ||'.'|| v_out_name(b) ||'_'|| AKT_EV ||'
		('|| v_pim_create_out ||' FROM '|| v_out_schema ||'.'|| v_out_szektor(x) ||'_'|| v_out_alszektor(x) ||'_'|| v_out_name(b) ||'_'|| AKT_EV ||'
		'
		;

		EXECUTE IMMEDIATE'
		DROP TABLE '|| v_out_schema ||'.'|| v_out_szektor(x) ||'_'||  v_out_alszektor(x) ||'_'|| v_out_name(b) ||'_'|| AKT_EV ||'
		'
		;

		END IF;

	END LOOP;

END LOOP;

END sector_unite;



BEGIN

V_PIM_INPUT(1) := 'PIM_FNN_NET';
V_PIM_INPUT(2) := 'PIM_FNN_GRS';
V_PIM_INPUT(3) := 'PIM_FNN_CFC';

v_pim(1) := 'net';
v_pim(2) := 'grs';
v_pim(3) := 'cfc';

END CFC;