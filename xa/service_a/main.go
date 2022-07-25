package main

import (
	"database/sql"
	"fmt"
	"gorm.io/gorm"
	"service_a/util"
	"strings"
	"time"

	"github.com/dtm-labs/client/dtmcli"
	"github.com/gin-gonic/gin"
	"gorm.io/driver/mysql"
)

type gormLogger struct{}

func (*gormLogger) Printf(format string, v ...interface{}) {
	format = strings.Replace(format, "\n", " ", 1)
	fmt.Println(fmt.Sprintf(format, v))
}

func main() {
	route := gin.New()
	route.POST("/jobA", util.WrapHandler(func(c *gin.Context) interface{} {

		now := uint64(time.Now().UnixNano() / int64(uint64(time.Millisecond)/uint64(time.Nanosecond)))

		return dtmcli.XaLocalTransaction(c.Request.URL.Query(), dtmcli.DBConf{
				Driver: "mysql",
				Host:   "127.0.0.1",
				Port:   13307,
				User:   "root",
				Password: "root",
			}, func(db *sql.DB, xa *dtmcli.Xa) error {
			var dia gorm.Dialector
			dia = mysql.New(mysql.Config{Conn: db})
			gdb, err := gorm.Open(dia, &gorm.Config{})
			if err != nil {
				return err
			}
			dbr := gdb.Exec("INSERT INTO `service_a`.`a`(`created_at`, `updated_at`, `deleted_at`) VALUES (?, ?, 0)", now, now)
			return dbr.Error
		})
	}))

	if err := route.Run(":5001"); err != nil {
		panic(err)
	}
}
