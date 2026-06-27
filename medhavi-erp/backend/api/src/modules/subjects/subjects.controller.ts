import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  ParseUUIDPipe,
  Patch,
  Post,
  Query,
  UseGuards,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { PermissionsGuard } from '../auth/guards/permissions.guard';
import { RequirePermissions } from '../auth/decorators/permissions.decorator';
import { SubjectsService } from './subjects.service';
import { CreateSubjectDto } from './dto/create-subject.dto';
import { ListSubjectsQueryDto } from './dto/list-subjects.query';
import { UpdateSubjectDto } from './dto/update-subject.dto';

/**
 * SubjectsController
 *
 * Permission keys mirror the faculty module:
 *   subjects.read   | subjects.create | subjects.update
 *   subjects.delete | subjects.restore
 */
@ApiTags('Subjects')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, PermissionsGuard)
@Controller({ path: 'subjects', version: '1' })
export class SubjectsController {
  constructor(private readonly subjects: SubjectsService) {}

  @Get()
  @RequirePermissions('subjects.read')
  @ApiOperation({ summary: 'List subjects (paginated, filterable).' })
  @ApiOkResponse({ description: 'Paginated list of subjects.' })
  list(@Query() query: ListSubjectsQueryDto) {
    return this.subjects.findAll(query);
  }

  @Get(':id')
  @RequirePermissions('subjects.read')
  @ApiOperation({ summary: 'Get a single subject by id.' })
  findOne(@Param('id', new ParseUUIDPipe()) id: string) {
    return this.subjects.findOne(id);
  }

  @Post()
  @RequirePermissions('subjects.create')
  @ApiOperation({
    summary: 'Create a new subject under a department (and optional program).',
  })
  create(@Body() dto: CreateSubjectDto) {
    return this.subjects.create(dto);
  }

  @Patch(':id')
  @RequirePermissions('subjects.update')
  @ApiOperation({ summary: 'Update a subject (partial).' })
  update(
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: UpdateSubjectDto,
  ) {
    return this.subjects.update(id, dto);
  }

  @Delete(':id')
  @RequirePermissions('subjects.delete')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Soft-delete a subject (sets deletedAt, isActive=false).',
  })
  remove(@Param('id', new ParseUUIDPipe()) id: string) {
    return this.subjects.remove(id);
  }

  @Post(':id/restore')
  @RequirePermissions('subjects.restore')
  @ApiOperation({ summary: 'Restore a previously soft-deleted subject.' })
  restore(@Param('id', new ParseUUIDPipe()) id: string) {
    return this.subjects.restore(id);
  }
}
